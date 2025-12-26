
require "nokogiri"
require "awesome_print"
require "css_parser"
require "cobweb"

class AppliedCSS

  @@MAX_ATTEMPTS = 3

  def initialize(options = {})
    @options = {:ancestors => false}.merge(options)
    @options[:cache] = 120 unless @options.has_key? :cache
    @options[:cache_type] = :full unless @options.has_key? :cache_type

    @options[:debug] = false unless @options.has_key? :debug
    
    @base_uri = Addressable::URI.parse(@options[:url])
    raise "url must be specified" unless @base_uri

    @doc = @options[:document]

    unless @doc
      html = get(@base_uri.to_s)
      @doc = Nokogiri::HTML.parse(html) unless html.nil?
    end

    puts "Genrating Parser." if @options[:debug]
    @parser = CssParser::Parser.new
    styles.each do |uri, style|
      puts "adding #{style}" if @options[:debug]
      @parser.add_block! style
    end
    @doc.css("style").each do |style_node|
      puts "adding #{style_node.text()}" if @options[:debug]
      @parser.add_block! style_node.text()
    end
  end

  def css(path)
    css_declarations = {}
    ancestors_and_self(path).each do |node|
      css_declarations.merge!(node_declarations(node))
    end
    css_declarations
  end

  def doc
    @doc
  end

  def to_s
    @parser.to_s
  end

  def styles
    populate_style_hash if @style_hash.nil?
    @style_hash
  end

  def to_hash
    hash = {}
    @parser.each_selector do |selector, declarations, specificity|
      hash[selector] = declarations
    end
    hash
  end

  def parser
    @parser
  end

  private
  def populate_style_hash
    @style_hash = {}
    @doc.search("link").each do |link|
      if link["rel"].downcase == "stylesheet"
        uri = @base_uri.join(link["href"]).to_s
        get_style(uri)
      end
    end
  end

  def get_style(uri)
    unless @style_hash.has_key?(uri)
      begin
        @style_hash[uri] = get(uri)
      rescue => e
        puts "Error: #{e.message}"
      end
      process_imports(uri)
    end
  end

  def process_imports(uri)
    if @style_hash[uri] =~ /@import (url\()?[\s'"]*([^"'\)]*?)[\s'"\)]*$/
      url = Addressable::URI.parse(uri).join($2)
      get_style(url)
    end
  end

  def node_declarations(node)
    declarations = {}
    node_identifications(node).each do |node_path|
      @parser.find_by_selector(node_path).each do |detected_decs|
        detected_decs.split(";").map{|detected_dec| declarations[detected_dec.split(":")[0].strip.to_s] = detected_dec.split(":")[1].strip}
      end
    end
    declarations
  end
  def node_identifications(node)

    # need to create a class for these and add a specificity to order based on priority

    #    puts "\033[31m WARNING - specificity has not been applied yet.\033[0m"

    identifications = []
    identifications << node.name

    unless node["id"].nil?
      identifications << "##{node["id"]}"
    end

    unless node["class"].nil?
      node["class"].split(" ").map{|css_class| identifications << ".#{css_class}"}
    end
    identifications
  end
  def ancestors_and_self(path)
    nodes = []
    node = @doc.at(path)
    if @options[:ancestors]
      nodes += node.ancestors[0..-2].reverse
    end
    nodes << node
    nodes.reject{|node| node.nil?}
  end

  def get(url)
    
    response = Cobweb.new(@options).get(url)
    raise "The style #{url} doesen't exist (404)" if response[:status_code].to_i == 404
    return response[:body]

    found = false
    attempts = 0
    @url = url
    uri = Addressable::URI.parse(url)
    until( found || attempts>=@@MAX_ATTEMPTS)
      uri.path = "/" if uri.path.empty?
      path = "#{uri.path}"
      path += "?#{uri.query}" unless uri.query.nil?
      request = Net::HTTP::Get.new(path, @http_options)
      response = Net::HTTP.start(uri.host, uri.port) {|http|
        http.request(request)
      }
      if response.code.to_i.between? 300, 399
        puts "redirecting to #{response["location"]}" if @options[:debug]
        uri = uri.merge(response["location"])
      elsif response.code.to_i == 404
        raise "The style #{url} doesen't exist (404)"
      elsif response.code.to_i.between? 400, 599
        raise "Error retrieving #{url} code #{response.code}"
      end
      found = true if response.code == "200"
      attempts += 1
    end
    response.body
  end
end
