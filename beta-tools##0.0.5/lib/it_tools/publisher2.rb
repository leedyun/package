require "pygments"
require "redcarpet"
require 'logger'
require_relative 'solr'

module Publisher
  class Markdown
    attr_accessor :is_markdown_file, :convert_to_html_filename, :ops, :log

    def initialize(ops = {})
      @ops = { :output_style_sheet => 'style.css' }
      @ops.merge! ops
      @is_markdown_file = lambda { |file| File.extname(file) == '.mmd' }
      @convert_to_html_filename = lambda { |filename| File.basename(filename, File.extname(filename)) + ".html" }
      @log = Logger.new('log.txt')
      if level = @ops[:debug_level]
        @log.level = level
      else
        @log.level = Logger::INFO
      end
    end

    def copy_src_if_newer(read_dir, write_dir)
      @log.info "Copying all files from: #{read_dir}, to: #{write_dir}, if they are newer in from dir."
      return unless Dir.exists? read_dir
      FileUtils.mkdir write_dir unless Dir.exists? write_dir
      Dir.foreach read_dir do |curr_file|
        read = File.absolute_path(File.join(read_dir,curr_file))
        next if File.directory? read
        write = File.absolute_path(File.join(write_dir,curr_file))
        FileUtils.cp_r read, write_dir if file_newer? read, write
        @log.debug "Copied from: #{read}, to: #{write}"
      end
    end
    def insert_css_link(file_list)
      style_info = '<head><LINK REL=StyleSheet HREF="' + @ops[:output_style_sheet] + '" TYPE="text/css"/></head>'
      prepend_string style_info, file_list
    end

    def prepend_string(string, file_list)
      file_list.each do |file|
        contents = File.open(file,'r'){|f| f.read }
        tmp_file = file + '.tmp'
        File.open(tmp_file, 'w'){|f| f.write string + contents}
        FileUtils.rm_f file
        FileUtils.mv tmp_file, file
      end
    end
    def copy_files_to_dir(to_dir, file_list)
      @log.debug "Copy to: #{to_dir}.  Files: #{file_list}"
      FileUtils.mkdir to_dir unless File.exists? to_dir
      raise "#{to_dir} is not a directory" unless File.directory? to_dir
      static_file_list = []
      file_list.each do |file| 
        FileUtils.cp file, to_dir
        static_file_list.push File.absolute_path(File.join(to_dir, File.basename(file)))
      end
      return static_file_list
    end
    def copy_solr_search_files ops, to_dir
      search_files = ops[:solr_search_files]
      solr_search_files_dir = ops[:solr_search_files_dir]
      @log.debug "Copying solr search files from: #{solr_search_files_dir}, to: #{to_dir}"
      search_files.each do |file| 
        from = File.join(solr_search_files_dir, file)
        FileUtils.cp from, to_dir
      end
    end
    def process_files(from_dir = @ops[:src_dir], to_dir = @ops[:target_dir])
      # Files for searching
      newer_files = get_newer_src_files from_dir, to_dir, @is_markdown_file, @convert_to_html_filename
      converted_files = convert_mmd_files newer_files, to_dir
      send_to_indexer converted_files, @ops[:search_category]
      copy_solr_search_files @ops, to_dir
      copy_src_if_newer File.join(from_dir, 'images'), File.join(to_dir, 'images')
      write_stylesheet from_dir, to_dir
      # Now static only files
      static_dir = to_dir + "_static"
      static_file_list = copy_files_to_dir static_dir, converted_files
      copy_src_if_newer File.join(from_dir, 'images'), File.join(static_dir, 'images')
      insert_css_link static_file_list
      write_stylesheet from_dir, static_dir
      create_index static_dir
    end
    def send_to_indexer(file_list, search_category)
      uploader = Solr::Upload.new(ops)
      file_list.each do |file|
        contents = File.open(file,'r'){ |f| f.read }
        extension = File.extname file
        file_name = File.basename file, extension
        @log.debug "Indexing the following: #{file_name}"
        uploader.upload_file file_name, contents, file_name, search_category
      end
    end
    def create_index(dir)
      files = File.join dir,'*.html'
      index = Dir.glob [files]
      index.sort! { |a,b| a.downcase <=> b.downcase }
      file = File.open(File.join(dir,"index.html"), 'w')
      file.write("<html><body><ul>")
      index.each { |filename|
        basename = File.basename(filename, File.extname(filename))
        file.write("<li/><a href=\"#{basename}.html\">#{basename}")
      }
      file.write("</ul></body></html>")
      file.close()
    end

    def write_stylesheet(read_dir,write_dir)
      contents = File.open(File.join(read_dir, @ops[:style_sheet]), "rb"){|f| f.read}
      css = Pygments.css
      File.open(File.join(write_dir,@ops[:output_style_sheet]), 'w') {|f| f.write(css + "\n" + contents) }
    end
    def convert_mmd_files(files_to_convert, target_dir)
      markdown = Redcarpet::Markdown.new(HTMLwithPygments,
                                         :fenced_code_blocks => true,
                                         :tables => true,
                                         :autolink => true,
                                         :with_toc_data => true)
      converted_files = []
      files_to_convert.each do |file|
        log.info "Working on file: " + file
        contents = File.open(file, "r"){|f| f.read}
        contents = contents.remove_non_ascii

        html = markdown.render(contents.force_encoding('US-ASCII'))
        log.debug "Converted markdown"
        target_file = get_target_file file, target_dir, @convert_to_html_filename
        write_file html, target_file
        converted_files.push target_file
      end
      return converted_files
    end
    def write_file( contents, out_file )
      File.open(out_file, 'w') { |f| f.write contents }
    end
    def get_target_file(src_filename, target_dir, make_target_filename = nil)
      if make_target_filename
        target_file_name = make_target_filename.call src_filename 
      else
        target_file_name = src_filename
      end
      target_file = File.absolute_path target_file_name, target_dir
    end
    def get_newer_src_files(src_dir, target_dir, is_wanted_src_file = nil, make_target_filename = nil)
      newer_src_files = []
      Dir.foreach(src_dir) do |curr_file|
        next if File.directory? curr_file
        if is_wanted_src_file 
          next unless is_wanted_src_file.call curr_file
        end
        target_file = get_target_file(curr_file, target_dir, make_target_filename)
        src_file = File.absolute_path curr_file, src_dir
        newer_src_files.push src_file if file_newer? src_file, target_file
      end
      return newer_src_files
    end
    def file_newer?(first_file, second_file)
      first_file_ts = File.stat(first_file).mtime
      return true unless File.exist?(second_file) 
      second_file_ts = File.stat(second_file).mtime
      if second_file_ts > first_file_ts
        return false
      else
        return true
      end
    end
  end

#---------------------------------------

  class HTMLwithPygments < Redcarpet::Render::HTML
    attr_accessor :ops, :log

    def initialize(options = {})
      super
      @ops = {:log_filename => 'log.txt'}
      @ops.merge! options
      @log = Logger.new(@ops[:log_filename])
      if level = @ops[:debug_level]
        @log.level = level
      else
        @log.level = Logger::INFO
      end
      $toc1 = ""
      $last_header_level = 0
      $last_header_count = 0
      $header = Array.new()
      0.upto(6) { |i| $header[i] = 0 }
    end

    def block_code(code, language)
      Pygments.highlight(code, :lexer => language)
    end
    def get_header_label( header_level )
      index = header_level - 1
      $header[index] = $header[index] + 1
      header_level.upto($header.length - 1) { |i| $header[i] = 0 }
      header_string = ""
      0.upto(header_level - 1) { 
        |i| if i == header_level - 1
              header_string += $header[i].to_s
              @log.debug "Header String: #{header_string}.  Header Entry: #{$header[i]}"
            else
              header_string += $header[i].to_s + "."
            end
      }
      @log.info "processed: " + header_string
      return header_string
    end
    def set_less_significant_to_zero(header_level)
      10.times {|i| p i+1}
    end
    def header(text, header_level)
      header_label = get_header_label(header_level)
      id = text.gsub(" ", "_") unless text.nil?
      $toc1 += "<div class=\"toc#{header_level}\"><a href=\"##{id}\">#{header_label} - #{text}</a></div><br/>\n"
      return "\n<h#{header_level} id=\"#{id}\">#{header_label} - #{text}</h#{header_level}>\n"
    end
    def postprocess(full_document)
      temp = $toc1
      $toc1 = ""
      0.upto(6) { |i| $header[i] = 0 }
      return temp + full_document
    end
  end
end
class String
  def remove_non_ascii(replacement="") 
    self.force_encoding('ASCII-8BIT').gsub(/[\x80-\xff]/,replacement)
  end
end
