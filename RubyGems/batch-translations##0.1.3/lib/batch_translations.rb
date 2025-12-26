module ActionView
  module Helpers
    class FormBuilder
      def globalize_fields_for(locale, *args, &proc)
        raise ArgumentError, "Missing block" unless block_given?
        @locale_index ||= {}

        if @locale_index[locale].nil?
          @index = @index ? @index + 1 : 1
          @locale_index[locale] = @index
        else
          @index = @locale_index[locale]
        end

        object_name = "#{@object_name}[translations_attributes][#{@index}]"
        object = @object.translations.select{|t| t.locale.to_s == locale.to_s}.first || @object.translations.find_by_locale(locale.to_s)
        @template.concat @template.hidden_field_tag("#{object_name}[id]", object ? object.id : "")
        @template.concat @template.hidden_field_tag("#{object_name}[locale]", locale)
        if @template.respond_to? :simple_fields_for
          @template.simple_fields_for(object_name, object, *args, &proc)
        elsif @template.respond_to? :semantic_fields_for
          @template.semantic_fields_for(object_name, object, *args, &proc)
        else
          @template.fields_for(object_name, object, *args, &proc)
        end
      end
    end
  end
end

module Globalize
  module ActiveRecord
    module InstanceMethods
      def update_attributes_with_translations(attributes)
        attributes.each do |key, value|
          if key == "translations_attributes"
            value.each do |rec_index, rec_value|
              locale = rec_value.delete("locale")
              write_attribute(rec_value.keys.first, rec_value.values.first, options = { :locale => locale })
            end
          else
            self.update_attribute(key, value)
          end
        end
      end
    end
  end

  module Model
    module ActiveRecord
      module Translated
        module Callbacks
          def enable_nested_attributes
            accepts_nested_attributes_for :translations
          end
        end
        module InstanceMethods
          def after_save
            init_translations
          end
          # Builds an empty translation for each available
          # locale not in use after creation
          def init_translations
            I18n.translated_locales.reject{|key| key == :root }.each do |locale|
              translation = self.translations.find_by_locale locale.to_s
              if translation.nil?
                translations.build :locale => locale
                save
              end
            end
          end
        end
      end
    end
  end
end
