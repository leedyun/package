require "bunto_test_plugin/version"
require "bunto"

module BuntoTestPlugin
  class TestPage < Bunto::Page
    def initialize(site, base, dir, name)
      @site = site
      @base = base
      @dir  = dir
      @name = name
      self.process(name)
      self.content = "this is a test"
      self.data = {}
    end
  end

  class TestGenerator < Bunto::Generator
    safe true

    def generate(site)
      site.pages << TestPage.new(site, site.source, '', 'test.txt')
    end
  end
end
