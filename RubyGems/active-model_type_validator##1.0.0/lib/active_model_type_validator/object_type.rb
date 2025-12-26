module ActiveModel

    module Validations

        # Implements the mechanics of <tt>validates_object_type_of</tt>.
        #
        # The standard <tt>#initialize</tt> and <tt>#validate_each</tt> methods are implemented.
        class ObjectTypeValidator < EachValidator

            # Standard initializer for an <tt>EachValidator</tt>.
            def initialize(options)
                @types = []
                # Remove :allow_blank since it's nonsensical when testing types
                options.delete(:allow_blank)
                # Set :allow_nil true if it's not present
                t = options[:allow_nil]
                options[:allow_nil] = true if t.nil?
                # Filter out missing or blank type entries and convert others
                # to class via constantize.
                t = Array(options.delete(:type))
                t.each do |te|
                    if te.is_a?(Class)
                        @types.append(te)
                    elsif te.is_a?(String)
                        begin
                            @types.append(te.constantize) unless te.blank?
                        rescue NameError
                            raise ArgumentError, "Type #{te} is invalid"
                        end
                    elsif te.is_a?(Symbol)
                        begin
                            @types.append(te.to_s.constantize)
                        rescue NameError
                            raise ArgumentError, "Type #{te.to_s} is invalid"
                        end
                    else
                        raise ArgumentError, "Type #{te.to_s} is a #{te.class.name} which is invalid"
                    end
                end
                raise ArgumentError, 'At least one type must be given' if @types.empty?
                super(options)
                check_validity!
            end

            # Standard validation method for an <tt>EachValidator</tt>.
            def validate_each(record, attr_name, value)
                errors_options = options.except(:type)
                errors_options[:type] = value.class
                right_type = false
                @types.each do |t|
                    # Entries in @types are classes, not strings
                    right_type = true if value.is_a?(t)
                end
                record.errors.add(attr_name, (options[:message] || :wrong_type), errors_options) unless right_type
            end

        end

        module HelperMethods

            # Validates that the specified attributes are of a given type (as defined by <tt>#is_a?</tt>).
            #
            #   class Person < ActiveRecord::Base
            #     validates_type_of :first_name, type: String
            #   end
            #
            # The +first_name+ attribute must be in the object and it must be a X.
            #
            # If you want to validate the type of a boolean field (where the real
            # types are +TrueClass+ and +FalseClass+), you will want to use
            # both those classes in the list of types and set +:allow_nil+ to false.
            #
            # By default this validator sets +:allow_nil+ to true to allow nil values to
            # pass through validation even though +NilClass+ isn't explicitly listed, and
            # you're expected to use a presence validator if you want the attribute to have
            # to be present (non-nil). You can set +:allow_nil+ to false to cause even nil
            # values to be checked against the type list and fail if NilClass isn't listed,
            # mimicking the effect of a presence validator.
            #
            # Configuration options:
            # * <tt>:type</tt> - An array of class names (or symbols or strings naming class
            #   names) which are legal for values of the attribute.
            # * <tt>:message</tt> - A custom error message (default is: "cannot be of type X").
            #   Messages can find the offending type name for interpolation in +:type+.
            #
            # There is also a list of default options supported by every validator:
            # +:if+, +:unless+, +:on+, +:allow_nil+, and +:strict+. +:allow_blank+ is
            # not allowed because it's nonsensical and confusing when applied to type
            # checking.
            # See <tt>ActiveModel::Validation#validates</tt> for more information
            def validates_object_type_of(*attr_names)
                validates_with ObjectTypeValidator, _merge_attributes(attr_names)
            end

        end

    end

end
