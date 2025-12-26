module ARLightning
  module ActiveRecord
    def lightning(*args)
      columns = args.present? ? args : column_names 
      connection.select_all(select(columns).arel).each do |attrs|
        attrs.each_key do |attr|
          attrs[attr] = type_cast_attribute(attr, attrs)
        end
      end
    end
  end
end
