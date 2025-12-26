require 'mechanize'
require_relative 'l1_result_page'

module BisearchEnzimHu

  # Primer Design Form (at http://bisearch.enzim.hu/?m=search)
  class PrimerDesign
    URL = "http://bisearch.enzim.hu/?m=search"
    attr_reader :chr, :start_pos, :end_pos, :page, :form, :primers, :url

    def initialize(options={})
      @agent = Mechanize.new
      @options = default_options.merge options
      @url = @options.delete :url
    end
    
    
    def sequence(seq, chr=nil, start_pos=nil)
      @primers = {}
      @chr           = chr
      @start_pos     = start_pos
      @end_pos       = start_pos + seq.size if start_pos
      @options[:seq] = seq
      prepare
      self
    end


    def prepare
      # filling form
      @page = @agent.get(@url)
      @form = @page.form
      @options.each_pair do |field_name, value|
        case get_type(field_name)
        when :select # a dropdown
          @form.field_with(name: field_name.to_s).options.find{|e| e.text.downcase=~Regexp.new(value.downcase)}.select
        when :checkbox
          @form.checkbox_with(name: field_name.to_s).send(value ? :check : :uncheck)
        when :radiobutton
          @form.radiobutton_with(name: field_name.to_s).send(value ? :check : :uncheck)
        when :text
          @form.field_with(name: field_name.to_s).value=value
        when :text_area
          @form.field_with(name: field_name.to_s).value=value # same as text
        end
      end
      self
    end

    def search(two_levels=true)
      @primers = {}
      puts "---> starting search primers"
      t = Time.now
      page = @agent.submit(@form)
      puts "---> query completed (time: #{Time.now-t}s)"
      @primers[:input] = {chr: @chr, start_pos: @start_pos, end_pos: @end_pos, seq: @options[:seq]}
      res_page = BisearchEnzimHu::L1ResultPage.new(page.body)
      # @primers[:output] = BisearchEnzimHu::L1ResultPage.new(page.body)
      @primers[:output] = res_page.parse(two_levels)
      self
    end

    def prune
      indexes_to_remove = []
      puts @primers.inspect
      puts @primers[:output].inspect
      @primers[:output].each_pair do |i, h|
        puts h.inspect
        indexes_to_remove << i if h[:fpcr][:sense][:results].size>1
        indexes_to_remove << i if h[:fpcr][:antisense][:results].size>1
      end
      indexes_to_remove.uniq!
      puts "results to remove: [#{indexes_to_remove.join(', ')}]"
      indexes_to_remove.each{|i| @primers[:output].delete(i)}
    end


    private
    def default_options
      { 
        bis: true,
        optlen: 30,
        mincpg: 0,
        db: "homo sapiens",
        url: URL
      }
    end

    def get_type(field_name)
      field_types[field_name.to_sym] || :text
    end

    def field_types
      # default is :text
      {
        bis: :checkbox,
        db: :select
      }
    end
  end
end


