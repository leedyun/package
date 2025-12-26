require 'faraday'
require 'faraday_middleware'
require 'mime/types'
require 'json'

module NinetyNine
  module Tasks
    class ApiClient
      def initialize(apikey, base_url: 'https://api.99designs.com/tasks/v1')
        @apikey = apikey
        @conn = Faraday.new(base_url) do |f|
          f.basic_auth apikey, ''
          f.request :multipart
          f.request :url_encoded
          # f.response :logger # DELETEME
          f.adapter Faraday.default_adapter
        end
      end

      def create_task(body: nil, urls: [], filenames: [], webhook_url: nil, external_id: nil)
        response = request :post, "tasks", { body: body, attachment: files(urls, filenames), webhook_url: webhook_url, external_id: external_id }

        interpret_response(response)
      end

      def get_task(task_id)
        response = request :get, "tasks/#{task_id}", nil

        interpret_response(response)
      end

      def my_tasks(external_id: nil, page: nil, per_page: nil)
        params = { external_id: external_id, page: page, per_page: per_page }.delete_if { |k, v| v.nil? }
        response = request :get, "tasks", nil, params: params

        interpret_response(response)
      end

      def update_task(task_id, params)
        response = request :put,"tasks/#{task_id}", { body: params[:body] }

        interpret_response(response)
      end

      def attach_files(task_id, urls: [], filenames: [])
        response = request :post, "tasks/#{task_id}/attachments", { attachment: files(urls, filenames) }

        interpret_response(response)
      end

      def delete_attachment(task_id, attachment_id)
        response = request :delete, "tasks/#{task_id}/attachments/#{attachment_id}", nil

        interpret_response(response)
      end

      def post_comment(task_id, comment)
        response = request :post, "tasks/#{task_id}/comment", { comment: comment }

        interpret_response(response)
      end

      def request_revision(task_id, delivery_id, revision_type, comment)
        response = request :post, "tasks/#{task_id}/deliveries/#{delivery_id}/request_revision", { revision_type: revision_type, comment: comment }

        interpret_response(response)
      end

      def approve_delivery(task_id, delivery_id)
        response = request :post, "tasks/#{task_id}/deliveries/#{delivery_id}/approve", nil

        interpret_response(response)
      end


      private

      def request(method, path, body, headers: {}, params: nil)
        @conn.run_request(method, path, body, headers) do |request|
          request.params.update(params) if params
        end
      end

      def interpret_response(response)
        status = response.status
        body = response.body

        begin
          json = JSON.parse(body, symbolize_names: true) if body != ''
        rescue JSON::ParserError
          raise NinetyNine::ApiError.new("Unexpected response: \"#{body}\" (http status: #{status})", status, body, nil)
        end

        if response_ok?(status)
          return json
        else
          raise error_for_response(status, body, json)
        end
      end

      def response_ok?(status)
        (200..299).include?(status)
      end

      def error_for_response(status, body, json)
        case status
        when 400
          NinetyNine::ValidationError.new(json['message'], status, body, json)
        when 401
          NinetyNine::AuthenticationError.new(json['message'], status, body, json)
        when 402
          NinetyNine::PaymentError.new(json['message'], status, body, json)
        when 404
          NinetyNine::NotFoundError.new(json['message'], status, body, json)
        when 422
          NinetyNine::InvalidStateError.new(json['message'], status, body, json)
        else
          NinetyNine::ApiError.new(json['message'] || "Unexpected error: \"#{body}\" (http status: #{status})", status, body, json)
        end
      end

      def files(urls, filenames)
        uploads = filenames.map do |filename|
          Faraday::UploadIO.new(filename, content_type(filename))
        end

        urls + uploads
      end

      def content_type(filename)
        types = MIME::Types.type_for(filename)

        if types.empty?
          'application/octet-stream'
        else
          types.first.content_type
        end
      end

    end
  end
end
