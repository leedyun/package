class ABBYY::Cloud
  module Models
    class Locale < String
      FORMAT = /\A[A-Za-z0-9]{2,}(-[A-Za-z0-9]+)*\z|\A[i|x](-[A-Za-z0-9]+)+\z/

      class << self
        def new(value)
          return unless value
          return super if value[FORMAT]
          raise <<-MESSAGE.gsub(" +\|", "")
            |'#{value}' is not a valid locale. See:
            |  RFC-5656 (https://tools.ietf.org/html/rfc5646) for valid format
            |  Full list of locales at http://www.iana.org/assignments/language-subtag-registry/language-subtag-registry
          MESSAGE
        end
        alias_method :[], :new
      end
    end

    # Registers type Types::Locale
    Types.register_type Locale
  end
end
