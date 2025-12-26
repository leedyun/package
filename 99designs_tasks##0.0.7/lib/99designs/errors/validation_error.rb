module NinetyNine
  class ValidationError < BaseError
    def errors
      @json_body['errors']
    end
  end
end
