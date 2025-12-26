module ArJsonSerialize
  module ActiveRecordExt
    def json_serialize(column)
      serialize column, ::ArJsonSerialize::Serializer
    end
  end
end
::ActiveRecord::Base.send :extend, ::ArJsonSerialize::ActiveRecordExt
