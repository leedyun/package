require_relative "file"

# Base class for specific operations
# It validates request and response using corresponding models
#
# @abstract
#
class ABBYY::Cloud
  module Operations
    class Base
      class << self
        include Forwardable

        def http_method(value = nil)
          @http_method = value.to_s.capitalize if value
          @http_method || "Post"
        end

        def path(&block)
          block ? @path = block : @path
        end

        def link(value = nil)
          value ? @link = value : @link
        end

        def request_type(value = nil)
          value ? (@request_type = value) : (@request_type || :json)
        end

        def request_body(model = nil, &block)
          provide_model :@request_body, model, &block
        end

        def request_query(model = nil, &block)
          provide_model :@request_query, model, &block
        end

        def response_type(value = nil)
          value ? (@response_type = value) : (@response_type || :json)
        end

        def response_body(model = nil, &block)
          provide_model :@response_body, model, &block
        end

        private

        def provide_model(variable, model, &block)
          value = instance_variable_get(variable)
          return value if value && model.nil? && block.nil?

          model ||= Class.new(Model)
                         .tap { |obj| obj.instance_eval(&block) if block }

          instance_variable_set(variable, model)
        end
      end

      include Dry::Initializer.define -> do
        param :settings
      end

      def_delegators :settings, :connection
      def_delegators :"self.class",
                     :link, :http_method, :path, :request_type, :request_body,
                     :request_query, :response_type, :response_body

      def call(file = nil, **data)
        mash      = Hashie::Mash.new(data)
        url       = mash.instance_eval(&path)
        multipart = prepare_multipart(file, **data) if file
        body      = prepare_request_body(multipart, data)
        query     = prepare_request_query(data)
        headers   = prepare_request_headers(multipart)
        res       = connection.call http_method, url, body: body,
                                                      query: query,
                                                      headers: headers
        handle_response_body res
      end

      private

      def prepare_multipart(data, content_type: "text/plain", **)
        name = SecureRandom.hex(10)
        file = File.new(data, content_type: content_type)
        part = Part.new(name, file.read, file.path)
        part.content_type = content_type
        MultipartBody.new [part]
      end

      def prepare_request_body(multipart, data)
        case request_type
        when :json then JSON(request_body[data].to_h)
        when :file then [nil, nil, multipart, nil].join("\r\n")
        else data
        end
      rescue => error
        raise ArgumentError.new(link, data, error.message)
      end

      def prepare_request_query(data)
        request_query[data]
      rescue => error
        raise ArgumentError.new(link, data, error.message)
      end

      def prepare_request_headers(multipart)
        headers = {}
        headers["accept"] = "application/json" if response_type == :json
        headers["content-type"] = \
          case request_type
          when :json then "application/json"
          when :file then "multipart/form-data; boundary=#{multipart.boundary}"
          end

        headers
      end

      def handle_response_body(data)
        case response_type
        when :json then response_body[JSON.parse(data)]
        when :file then StringIO.new(data)
        else data
        end
      rescue => error
        raise TypeError.new(link, data, error.message)
      end
    end
  end
end
