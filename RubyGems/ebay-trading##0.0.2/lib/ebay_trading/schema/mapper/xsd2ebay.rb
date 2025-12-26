module EbayTrading
  module Schema
    class XSD2eBay
      include EbayTrading

      def self.run(data, directory)
        xsd = Parser.parse(data)
        importer = ApiSchemaImporter.new(xsd, data)
        importer.export_classes(directory)
      end
    end
  end
end