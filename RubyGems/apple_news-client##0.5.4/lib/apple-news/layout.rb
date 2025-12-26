module AppleNewsClient
  class Layout
    include Properties

    required_properties :columns, :width
    optional_properties :gutter, :margin, :ignoreDocumentMargin
  end
end
