# @author Todd Knarr <tknarr@silverglass.org>
#
# Top-level namespace for the ActiveModelSerializerPlus extensions.
#
# The methods and module variables here aren't commonly used directly by applications, they're
# mainly for internal use by the Assignment, JSON and Xml namespaces. You'll want to become familiar
# with the contents if you want to extend the set of types/classes handled automatically during
# serialization and deserialization.
#
# Currently the formatting-related functionality is unused. It's included for use in a planned
# XML serialization/deserialization extension.
module ActiveModelSerializerPlus

    private

    # Pseudo-parent-class names for classes that can be handled by a common
    # Proc even though they don't derive from a common parent class. That includes
    # container classes, although we don't do anything with them yet.
    @@type_name_xlate = {
        'TrueClass' => 'Boolean',
        'FalseClass' => 'Boolean',
        'Hash' => 'Container',
        'Array' => 'Container'
    }

    # If a class is listed here use the Proc to format it into a string, otherwise just use to_s
    @@formatting = {
        'Date' => Proc.new { |date| date.xmlschema },
        'DateTime' => Proc.new { |datetime| datetime.xmlschema },
        'Time' => Proc.new { |time| time.xmlschema }
    }

    # If a class is listed here, use the Proc to parse a string into an object of the right class
    @@parsing = {
        'Symbol' => Proc.new { |symbol| symbol.to_sym },
        'Time' => Proc.new { |time| Time.xmlschema(time) rescue ::Time.parse(time) },
        'Date' => Proc.new { |date| Date.xmlschema(date) rescue ::Date.parse(date) },
        'DateTime' => Proc.new { |datetime| DateTime.xmlschema(datetime) rescue ::DateTime.parse(datetime) },
        'Integer' => Proc.new { |integer| integer.to_i },
        'Float' => Proc.new { |float| float.to_f },
        'BigDecimal' => Proc.new { |number| BigDecimal(number) },
        'Boolean' => Proc.new { |boolean| %w(1 true).include?(boolean.to_s.strip.downcase) }
    }

    # If a class is listed here, use the Proc to build it from a Hash, otherwise use the
    # standard hash initialization method.
    #
    # This is used to deal with really unpleasant cases where a class is serialized as a hash but
    # can't be constructed from a hash or the values in the hash and we can't for whatever reason
    # insert a new method into the class to do the job.
    @@building = {
        'IPAddr' => Proc.new { |addr_hash|
            fam = addr_hash['family']
            addr = addr_hash['addr']
            mask = addr_hash['mask_addr']
            # Kludgy. IPAddr has no way to build from the hash or it's contents so we depend
            # on #new accepting an integer address parameter correctly.
            result = IPAddr.new(addr, fam)
            # Kludgy. All we have is the integer netmask but we need either the prefix length as an
            # integer or the netmask as a string of octets. So we use the same #new behavior as above
            # to take the netmask integer value and convert it to a netmask string through an IPAddr
            # object.
            netmask = IPAddr.new(mask,fam).to_s
            result.mask(netmask)
        }
    }

    public

    # Translate a type/class name to it's psuedo-parent class name if it has one.
    # @param [String] class_name the name of the class to translate
    # @return [String] the translated name
    def self.type_name_xlate(class_name)
        @@type_name_xlate[class_name]
    end

    # Format a value into a string using the defined formatting Proc for <tt>value</tt>'s class.
    # @note If no formatting Proc is defined, <tt>#to_s</tt> is used instead.
    # @note Checks all parent classes of <tt>value</tt> for Procs.
    # @param [Object] value the value to format
    # @return [String] the value formatted into a string
    def self.format(value)
        # Check the translation table first for a pseudo-parent, and if we found one check
        # for it's proc. Then start with the value's class name and work up through it's
        # parent classes until we find a proc for one. If we can't find a proc, just use
        # the #to_s method.
        p = nil
        n = @@type_name_xlate[value.class.name]
        p = @@formatting[n] unless n.nil?
        if p.nil?
            b = value.class
            until b.nil? do
                p = @@formatting[b.name]
                break unless p.nil?
                b = b.superclass
            end
        end
        p ? p.call(value) : value.to_s
    end

    # Parse a string value into an object of the named type if a parsing Proc is defined.
    # @note Checks all parent classes of <tt>class_name</tt> for Procs.
    # @param [String] class_name name of the class of object being created from the value
    # @param [String] value the string containing the formatted value to be parsed
    # @return [Object] the new object, or nil if no parsing Proc for <tt>class_name</tt> is defined
    def self.parse(class_name, value)
        # Check for a proc for the type name given, and if we find one use it. Otherwise
        # try to convert that name to a class. If we can, start with it and work up through
        # it's parent classes checking for a proc for each. If we can't find a proc, return
        # nil.
        p = nil
        xlt = @@type_name_xlate[class_name] || class_name
        p = @@parsing[xlt] unless xlt.nil?
        if p.nil?
            klass = nil
            begin
                klass = class_name.constantize
            rescue NameError
                klass = nil
            end
            until klass.nil?
                p = @@parsing[klass.name]
                break unless p.nil?
                klass = klass.superclass
            end
        end
        p ? p.call(value.to_s) : nil
    end

    # Build an object of the named type from a hash if a building Proc is defined.
    # @param [String] class_name name of the class of object being built from the hash
    # @param [Hash] hash hash containing the attribute names and values from which the object is to be built
    # @return [Object] the new object, or nil if no building Proc for <tt>class_name</tt> is defined
    def self.build(class_name, hash)
        p = nil
        xlt = @@type_name_xlate[class_name] || class_name
        p = @@building[xlt] unless xlt.nil?
        p ? p.call(hash) : nil
    end

    # Add a new type translation.
    # Translations are used to create pseudo-parent classes in cases where several classes can use common
    # Procs for formatting, parsing and/or building but don't share a common parent class, eg. TrueClass
    # and FalseClass which can both use the Boolean formatting and parsing Procs.
    # @param [String] type_name name of the specific type
    # @param [String] parent_type_name name of the pseudo-parent type
    # @return [void] no return value
    def self.add_xlate( type_name, parent_type_name )
        return if type_name.blank?
        @@type_name_xlate[type_name] = parent_type_name unless parent_type_name.blank?
        return
    end

    # Add information about a new type to the formatting/parsing/building hashes.
    # <tt>type_name</tt> is required, all others are optional and should be specified as <tt>nil</tt>
    # if not being defined.
    # @param [String] type_name name of the type to add
    # @param [Proc] formatting_proc Proc to add to format an object's value into a string
    # @param [Proc] parsing_proc Proc to add to parse a string value and create an object from it
    # @param [Proc] building_proc Proc to add to create an object from a hash of attribute names and values
    # @return [void] no return value
    def self.add_type(type_name, formatting_proc = nil, parsing_proc = nil, building_proc = nil)
        return if type_name.blank?
        @@formatting[type_name] = formatting_proc unless formatting_proc.nil?
        @@parsing[type_name] = parsing_proc unless parsing_proc.nil?
        @@building[type_name] = building_proc unless building_proc.nil?
        return
    end

    # Helper method to convert a type/class name into an actual class.
    # @param [Class, Symbol, String] class_name name to convert into a Class object
    # @return [Class] Class object for the named class
    # @raise [ArgumentError] if <tt>class_name</tt> is not of an acceptable type
    # @raise [NameError] if <tt>class_name</tt> is a Class that doesn't exist
    def self.to_class(class_name)
        klass = nil
        if class_name.is_a?(Class)
            klass = class_name
        elsif class_name.is_a?(String)
            begin
                klass = class_name.constantize unless class_name.blank?
            rescue NameError
                raise ArgumentError, "Type #{class_name} is invalid"
            end
        elsif class_name.is_a?(Symbol)
            begin
                klass = class_name.to_s.constantize
            rescue NameError
                raise ArgumentError, "Type #{class_name.to_s} is invalid"
            end
        else
            raise ArgumentError, "Type #{class_name.to_s} is invalid"
        end
        klass
    end

    # Helper method to convert a representation of a class or class name into a string containing the class name.
    # @param [Class, Symbol, String] class_name the Class whose name you need or a symbol or string representing a class name
    # @return [String] the class name represented by <tt>class_name</tt> converted to a string
    # @raise [ArgumentError] if <tt>class_name</tt> is not of an acceptable type
    # @raise [NameError] if <tt>class_name</tt> is a Class that doesn't exist
    def self.to_classname(class_name)
        klassname = nil
        if class_name.is_a?(Class)
            klassname = class_name.name
        elsif class_name.is_a?(String)
            klassname = class_name
        elsif class_name.is_a?(Symbol)
            klassname = class_name.to_s
        else
            raise ArgumentError, "Argument type #{class_name.class.name} is not Class, String or Symbol"
        end
        klassname
    end

end
