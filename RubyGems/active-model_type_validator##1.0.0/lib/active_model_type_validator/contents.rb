module ActiveModel

    module Validations

        # Implements the mechanics of <tt>validates_contents_of</tt>.
        class ContentsValidator < ActiveModel::EachValidator

            # Standard validation method for an <tt>EachValidator</tt>.
            def validate_each(object, attribute, value)
                if Array.wrap(value).reject { |r| r.valid? }.any?
                    object.errors.add(attribute, :invalid, options.merge(:value => value))
                end
            end

        end

        module HelperMethods

            # An implementation of the associated validator from ActiveRecord.
            # All options and behaviors are identical. It simply calls #valid? on each
            # of the attributes listed and returns the logical AND of them all.
            def validates_contents_of(*attr_names)
                validates_with ContentsValidator, _merge_attributes(attr_names)
            end

        end

    end

end
