require 'active_model_serializer_plus/translations'

module ActiveModelSerializerPlus

    private

    # Add a new value to an array-like container. `index` will be ignored.
    @@add_to_arraylike_proc = Proc.new { |container, index, value|
        container << value
    }
    # Add a new key and it's value to a hash-like container.
    @@add_to_hashlike_proc = Proc.new { |container, key, value|
        container[key] = value
    }

    # Populate  a new container from an array-like value
    @@build_from_arraylike_proc = Proc.new { |container, add_proc, obj_klass, value_container|
        index = 0
        value_container.each do |item|
            obj = ActiveModelSerializerPlus.build_object(obj_klass, item)
            add_proc.call(container, index, obj) unless obj.nil?
            index += 1
        end
    }
    # Populate a new container from a hash-like value
    @@build_from_hashlike_proc = Proc.new { |container, add_proc, obj_klass, value_container|
        value_container.each do |key, item|
            obj = ActiveModelSerializerPlus.build_object(obj_klass, item)
            add_proc.call(container, key, obj) unless obj.nil?
        end
    }

    # Map container type names to the procs that iterate through that kind of container.
    #
    # You can probably treat the array-like and hash-like procs as standard procs to
    # handle building from any container that acts like an array (iterates values, indexes are
    # integers starting from 0) or hash (iterates keys and values).
    # @note we need both iterator and adder procs so we can build arrays from hashes and vice-versa without
    #   having to manually list out every permutation.
    @@container_iterators = {
        'Array' => @@build_from_arraylike_proc,
        'Hash' => @@build_from_hashlike_proc
    }

    # Map container type names to the procs that add a new item to that kind of container.
    #
    # Again you can probably treat the array-like and hash-like procs as standard procs
    # to add items to any container that behaves like an array or hash.
    @@container_adders = {
        'Array' => @@add_to_arraylike_proc,
        'Hash' => @@add_to_hashlike_proc
    }

    public

    # Look up iterator proc.
    def self.get_container_iterator(typename)
        @@container_iterators[typename]
    end

    # Look up adder proc.
    def self.get_container_adder(typename)
        @@container_adders[typename]
    end

    # Break out the logic for creating a new object of a class from a hash or string value.
    # It's needed for both individual attributes and for each element of a
    # container.
    # @param [Class] obj_klass class of the object to create
    # @param [String, Hash] value value to use to initialize the object
    # @return [Object] newly-created object or nil
    # @raise [ArgumentError] if the object cannot be created
    def self.build_object(obj_klass, value)
        obj = nil
        if value.is_a?(Hash)
            # If we're looking at a contained object (our value is a hash), see if we have a Proc
            # to build the object from a hash. If we don't, fall back to creating an object and
            # using the hash #attributes= method if possible. If all else fails just leave the value
            obj = ActiveModelSerializerPlus.build(obj_klass.name, value)
            if obj.nil? && obj_klass.method_defined?('attributes=')
                obj = obj_klass.new
                if obj.nil?
                    raise ArgumentError, "Cannot create object of type #{obj_klass.name}."
                end
                obj.attributes = value
            end
        elsif value.is_a?(String)
            obj = ActiveModelSerializerPlus.parse(obj_klass.name, value)
        end
        obj
    end

    # Add iterator and adder procs for a new kind of container.
    # @param [String] typename type name of the container type to add
    # @param [Proc] iterator_proc Proc to build from that type of container
    # @param [Proc] adder_proc Proc to add an item to that type of container
    # @return [void]
    def self.add_container(typename, iterator_proc, adder_proc)
        return if typename.blank? || iterator_proc.nil? || adder_proc.nil?
        @@container_iterators[typename] = iterator_proc
        @@container_adders[typename] = adder_proc
        ActiveModelSerializerPlus.add_xlate(typename, 'Container')
        return
    end

    # Add a new kind of Array-like container
    # @param [String] typename type name of the container type to add
    # @return [void]
    def self.add_arraylike_container(typename)
        return if typename.blank?
        @@container_iterators[typename] = @@build_from_arraylike_proc
        @@container_adders[typename] = @@add_to_arraylike_proc
        ActiveModelSerializerPlus.add_xlate(typename, 'Container')
        return
    end

    # Add a new kind of Hash-like container
    # @param [String] typename type name of the container type to add
    # @return [void]
    def self.add_hashlike_container(typename)
        return if typename.blank?
        @@container_iterators[typename] = @@build_from_hashlike_proc
        @@container_adders[typename] = @@add_to_hashlike_proc
        ActiveModelSerializerPlus.add_xlate(typename, 'Container')
        return
    end

    # @author Todd Knarr <tknarr@silverglass.org>
    #
    # Default implementation of the <tt>#attributes=</tt> method for ActiveModel classes.
    #
    # This is the base of the JSON and Xml modules. It supplies a standard <tt>#attributes=</tt> method to
    # classes that follows the basic pattern of the custom one you'd normally write and adds the ability
    # to pick up object type information from the <tt>#attributes_types</tt> hash to convert the hash values of
    # contained objects into actual objects. This mostly eliminates the need to write custom <tt>#attributes=</tt>
    # methods for each class with code to check attribute names and initialize objects from child hashes.
    #
    # The standard ActiveModel/ActiveRecord serialization/deserialization has some flaws, for instance it
    # will serialize classes as contained hashes whether or not they have an <tt>#attributes=</tt> method available
    # to deserialize them. We work around that by having building Procs which can do the correct thing in
    # many cases.
    module Assignment

        # The default <tt>#attributes=</tt> method which assigns a hash to the object's attributes.
        # @param [Hash] hash the hash of attribute names and values
        # @return [self] self
        # @raise [ArgumentError] if any error occurs
        def attributes=(hash)
            hash.each do |key, value|
                # Check #attribute_types for what type this item should be, and if we have an entry
                # convert it to an actual Class object we can use.
                attr_klass = nil
                attr_typename = nil

                attr_typename = self.attribute_types[key] if self.respond_to?(:attribute_types) && self.attribute_types.is_a?(Hash)
                if attr_typename.is_a?(Array)
                    # Container

                    container_klass = nil
                    object_klass = nil

                    if attr_typename.length != 2
                        raise ArgumentError, "Container type specification for attribute #{key.to_s} is invalid."
                    end

                    # Sort out the type of container. First make sure the container type name translates to 'Container'.
                    # If the type name actually is 'Container', take the type of the container from the type of the
                    # original value. If it's an actual type name, convert it to a Class object. Raise exceptions if
                    # any problems are encountered.
                    container_typename = attr_typename[0]
                    if container_typename == 'Container'
                        container_klass = value.class
                    else
                        xlated_container_typename = ActiveModelSerializerPlus.type_name_xlate(container_typename)
                        if xlated_container_typename != 'Container'
                            raise ArgumentError, "Container type #{container_typename} for attribute #{key.to_s} is not a container."
                        end
                        begin
                            container_klass = ActiveModelSerializerPlus.to_class(container_typename)
                        rescue ArgumentError
                            raise ArgumentError, "Container type #{container_typename} for attribute #{key.to_s} is not a valid type."
                        end
                    end

                    # Sort out the type of objects in the container. Convert the object type name to a Class object
                    # and raise an exception if it can't be converted.
                    object_typename = attr_typename[1]
                    begin
                        object_klass = ActiveModelSerializerPlus.to_class(object_typename)
                    rescue ArgumentError
                        raise ArgumentError, "Object type #{object_typename} for attribute #{key.to_s} is not a valid type."
                    end

                    container = container_klass.new
                    if container.nil?
                        raise ArgumentError, "Cannot create container of type #{container_klass.name}."
                    end
                    adder_proc = ActiveModelSerializerPlus.get_container_adder(container_klass.name)
                    iterator_proc = ActiveModelSerializerPlus.get_container_iterator(value.class.name)
                    if adder_proc.nil? || iterator_proc.nil?
                        msg = ''
                        if iterator_proc.nil?
                            msg << "iterate through #{value.class.name}"
                        end
                        if adder_proc.nil?
                            if msg.length == 0
                                msg << ', '
                            end
                            msg << "add to #{container_klass.name}"
                        end
                        raise ArgumentError, "Cannot #{msg}."
                    end
                    # Build the new container by iterating through the value container and adding each item to
                    # the new container, using the procs we looked up.
                    iterator_proc.call(container, adder_proc, object_klass, value)

                    self.send("#{key}=", container)

                else
                    # Object

                    unless attr_typename.nil?
                        begin
                            attr_klass = ActiveModelSerializerPlus.to_class(attr_typename)
                        rescue ArgumentError
                            raise ArgumentError, "Type #{attr_typename.to_s} for attribute #{key.to_s} is not a valid type."
                        end

                        v = ActiveModelSerializerPlus.build_object(attr_klass, value)
                        value = v unless v.nil?
                    end

                    self.send("#{key}=", value)

                end

                self
            end

        end

    end

end
