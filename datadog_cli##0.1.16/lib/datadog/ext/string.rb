unless String.method_defined? :clean
  class String
    def clean
      self
        .gsub(/[^0-9A-Za-z]/,'-')
        .gsub(/\-{2,}/,'-')
        .gsub(/^\-/, '')
        .gsub(/\-$/, '')
        .downcase
    end
  end
end

unless String.method_defined? :hyphenate
  class String
    def hyphenate
      self
        .gsub(/([A-Z]+)([A-Z][a-z])/,'\1-\2')
        .gsub(/([a-z\d])([A-Z])/,'\1-\2')
        .clean
        .downcase
    end
  end
end
