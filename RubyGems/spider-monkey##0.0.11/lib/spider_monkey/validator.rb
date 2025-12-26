module SpiderMonkey
  class Validator
    def initialize(options = {})
      @options = options
    end
    
    def validate_options
      @passed = true
      @recoverable = true
      @valid_options = {}
      @invalid_options = {}
      @messages = []
      
      @options.each do |key, value|
        # First, lets loop through them all and remove any invalid keys
        if !is_allowed_root_key?(key)
          @invalid_options[key] = value
          @options.delete(key)
          @messages << "Extra Key present: #{key}"
        end
      end
      
      
      if is_source?(@options, "source")
        @valid_options[:source_url] = @options[:source_url] if @options[:source_url]
        @valid_options[:source_key] = @options[:source_key] if @options[:source_key]
        @valid_options[:source_bucket] = @options[:source_bucket] if @options[:source_bucket]
      else
        @messages << "Invalid Source."
        @recoverable = false
        @invalid_options[:source_url] = @options[:source_url] if @options[:source_url]
        @invalid_options[:source_key] = @options[:source_key] if @options[:source_key]
        @invalid_options[:source_bucket] = @options[:source_bucket] if @options[:source_bucket]
      end
      
      @options.delete(:source_url)
      @options.delete(:source_key)
      @options.delete(:source_bucket)
      
      
      validate_option(:string, :key, true) # This is the user API key, not the source key. Probably should rename this.
      validate_option(:integer_like, :width, true)
      validate_option(:integer_like, :height, true)
      validate_option(:colorspace, :read_colorspace)
      validate_option(:integer_like_or_auto, :read_density)
      validate_option(:integer_like, :quality)
      validate_option(:resize_method, :resize_method)
      validate_option(:gravity, :resize_gravity)
      validate_option(:boolean, :thumbnail)
      validate_option(:integer_like, :density)
      validate_option(:colorspace, :colorspace)
      validate_option(:color, :background_color)
      validate_option(:string, :template)
      validate_option(:alpha, :alpha)
      validate_option(:integer_like, :frame)
      
      
      # Merge Variables
      @valid_options[:template_merge_variables] = @options[:template_merge_variables] if @options[:template_merge_variables]

      #:annotate,
      @valid_options[:annotate] = @options[:annotate] if @options[:annotate]
      #:composite
      @valid_options[:composite] = @options[:composite] if @options[:composite]
      
      #:annotate
        # array, or single element
          # :gravity
          # :weight integer
          # :pointsize interger
          # :color "blue", "#123456", "rgb(1,1,1)", "rgba(12,12,12)"
          # :translate_x integer
          # :translate_y integer
          # :text (required) string
      
      # :composite
      #   :url / :key && :bucket
      #   width  numeric or percentage
      #   height
      #   :resize_gravity
      #   :disolve_percent optional - integer 0-100


      if @messages.size > 0
        @passed = false
      end
      
      SpiderMonkey.configuration[:validation_error_handler].call(@messages, @recoverable, @valid_options, @invalid_options) unless @passed
      return {
        passed: @passed,
        recoverable: @recoverable,
        valid_options: @valid_options
      }
    end
    
    def validate_option(validation_type, key, required = false)
      if @options[key].present?
        if send("is_#{validation_type}?".to_sym, @options[key])
          @valid_options[key] = @options[key]
        else
          @recoverable = false
          @messages << "Invalid parameter: #{key}."
          @invalid_options[key] = @options[key]
        end
      elsif required
        @recoverable = false
        @messages << "Missing parameter: #{key}"
      end
      @options.delete(key)
    end
    
    
    def is_integer_like?(input)
      is_integer?(input) || /\A[-+]?\d+\z/ === input
    end
    
    def is_integer_like_or_auto?(input)
      input == "auto" || input == :auto || is_integer_like?(input)
    end
    
    def is_integer?(input)
      input.kind_of? Integer
    end
    
    def is_string?(input)
      input.kind_of?(String) && !input.blank?
    end
    
    def is_symbol?(input)
      input.kind_of? Symbol
    end
    
    def is_boolean?(input)
      input.kind_of?(TrueClass) || input.kind_of?(FalseClass)
    end
    
    def is_color?(input)
      # This is really just a semi-validator.
      return false unless is_string?(input) || is_symbol?(input)
      
      input = input.to_s
      
      if input.starts_with?("#")
        # We have a hash color
        # All Valid:
        # #00F
        # #0000FF
        # #0000FFFF (w/ alpha)
        return false unless [4, 7, 9].include?(input.length)
        hex_input = input[1..(input.length)] # everything except the first character
        return !hex_input[/\H/]
      elsif input.starts_with?("rgba")
        # 1 of each parentheses and 3 commas
        return input.scan("(").count == 1 && input.scan(")").count == 1 && input.scan(",").count == 3
      elsif input.starts_with?("rgb")
        # 1 of each parentheses and 2 commas
        return input.scan("(").count == 1 && input.scan(")").count == 1 && input.scan(",").count == 2
      else
        # Some other string. We're going to just assume it's a color. In an
        # ideal world we would check it against the valid list, but that's way
        # too detailed.
        return true
      end
    end
    
    def is_gravity?(input)
      %w(
        northwest
        north
        northeast
        west
        center
        east
        southwest
        south
        southeast
      ).include?(input.to_s.downcase)
    end
    
    def is_colorspace?(input)
      %w(
        CIELab
        CMY
        CMYK
        Gray
        HCL
        HCLp
        HSB
        HSI
        HSL
        HSV
        HWB
        Lab
        LCH
        LCHab
        LCHuv
        LMS
        Log
        Luv
        OHTA
        Rec601Luma
        Rec601YCbCr
        Rec709Luma
        Rec709YCbCr
        RGB
        scRGB
        sRGB
        Transparent
        XYZ
        xyY
        YCbCr
        YDbDr
        YCC
        YIQ
        YPbPr
        YUV
      ).include?(input.to_s)
    end
    
    def is_alpha?(input)
      %w(
        Activate
        Associate
        Deactivate
        Disassociate
        Set
        Opaque
        Transparent
        Extract
        Copy
        Shape
        Remove
        Background
      ).include?(input.to_s)
    end
    
    def is_percent?(input)
      # String, with a percent sign, and an integer
      input.kind_of?(String) && input.include?('%') && is_integer_like?(input.gsub('%', ''))
    end
    
    def is_url?(input)
      # Super lame test
      is_string?(input) && ( input.starts_with?("http://") || input.starts_with?("https://") ) && input.length > 10
    end
    
    def is_resize_method?(input)
      return false unless is_string?(input) || is_symbol?(input)
      ["crop", "fit"].include? input.to_s.downcase
    end
    
    def is_source?(input, prefix = nil)
      return false unless input.kind_of? Hash 
      
      if prefix.present?
        prefix = prefix + "_"
      end
      
      if input.has_key?("#{prefix}url".to_sym)
        return false unless !input.has_key?("#{prefix}bucket".to_sym) && !input.has_key?("#{prefix}key".to_sym)
        return is_url?(input["#{prefix}url".to_sym])
      elsif (input.has_key?("#{prefix}bucket".to_sym) && input.has_key?("#{prefix}key".to_sym))
        return false unless !input.has_key?("#{prefix}url".to_sym)
        return (is_string?(input["#{prefix}bucket".to_sym]) && is_string?(input["#{prefix}key".to_sym]))
      else
        return false
      end
    end
    
    def is_allowed_root_key?(symbol)
      [
        :key,
        :source_url,
        :source_key,
        :source_bucket,
        :read_density,
        :read_colorspace,
        :quality,
        :width,
        :height,
        :resize_method,
        :resize_gravity,
        :thumbnail,
        :density,
        :colorspace,
        :annotate,
        :composite,
        :background_color,
        :template,
        :template_merge_variables,
        :frame,
        :alpha
      ].include?(symbol)
    end
    
    def is_allowed_annotate_key?(symbol)
      [
        :gravity,
        :weight,
        :pointsize,
        :color,
        :translate_x,
        :translate_y,
        :text
      ].include?(symbol)
    end
    
    def is_allowed_composite_key?(symbol)
      [
        :url,
        :key,
        :bucket,
        :width,
        :height,
        :resize_gravity,
        :disolve_percent
      ].include?(symbol)
    end
  end
end