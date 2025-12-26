class ContributorsStats::Formatter

  # generate html for a contributor, by default it will create a link to profile with contributor avatar
  class Html
    # default template building link to profile with contributor avatar
    DEFAULT_TEMPLATE = %q{%Q{<a href="#{data['html_url']}" title="#{login} - #{data['contributions']}"><img src="#{data['avatar_url']}" alt="#{login} - #{data['contributions']}"/></a>}}

    # access to the template used to generate content
    attr_accessor :template

    # create the generator object
    # @option template [String] the template to use, if not given default will be used
    def initialize(options = {})
      @template = options[:template] || DEFAULT_TEMPLATE
    end

    # format user data using template
    # @param login [String] user name
    # @param data [Hash] user data
    # @return [String]
    def format(login, data)
      eval(template)
    end

  end
end
