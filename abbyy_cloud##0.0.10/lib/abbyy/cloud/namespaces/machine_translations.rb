require_relative "base"

class ABBYY::Cloud
  module Namespaces
    # Namespace for operations with machine translations
    # @see [https://api.abbyy.cloud/swagger/ui/index#!/MachineTranslation]
    class MachineTranslations < Base
      # Returns list of all available engines
      # @return [Array<ABBYY::Cloud::Models::Engine>]
      def engines
        Operations::Engines.new(settings).call
      end

      # Returns engine object selected by its name
      # @return [ABBYY::Cloud::Models::Engine]
      def engine(name)
        engines.find { |engine| engine.name == name }
      end

      # Returns engine object for the default engine
      # @return [ABBYY::Cloud::Models::Engine]
      def default_engine
        engine(settings.engine)
      end

      # Instantly (synchronously) translates the text
      #
      # @example
      #   translate "Hello world!", from: "en", to: "fr_FR"
      #
      # @param  [String] text
      # @option [ABBYY::Cloud::Types::Locale] :from Source language
      # @option [ABBYY::Cloud::Types::Locale] :to   Target language
      # @return [ABBYY::Cloud::Models::Translation]
      #
      def translate(text, from:, to:, **opts)
        Operations::Translate.new(settings).call source_text:     text,
                                                 source_language: from,
                                                 target_language: to,
                                                 engine: settings.engine,
                                                 **opts
      end

      # Instantly (synchronously) translates array of texts
      #
      # @example
      #   translate ["Hello", "world"], from: "en", to: "fr_FR"
      #
      # @param  [Array<String>] texts
      # @option [ABBYY::Cloud::Types::Locale] :from Source language
      # @option [ABBYY::Cloud::Types::Locale] :to   Target language
      # @return [ABBYY::Cloud::Models::Translation]
      #
      def translate_segments(texts, from:, to:, **opts)
        sources = texts.map { |text| { text: text } }
        Operations::TranslateSegments
          .new(settings)
          .call sources: sources, from: from, to: to, engine: settings.engine,
                **opts
      end
    end
  end
end
