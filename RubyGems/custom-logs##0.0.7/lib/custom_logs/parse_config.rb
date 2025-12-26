module CustomLogs
  class ParseConfig

    @@config = nil

    class << self

      def get
        @@config ||= YAML.load_file('config/custom_logs.yml')[Rails.env].with_indifferent_access
      end

    end


  end
end