require "pygments"
require "redcarpet"
require "RedCloth"
require 'pathname'
require 'fileutils'
require 'logger'

require_relative 'solr'
require_relative 'shared'

module Website
  class HTMLwithPygments < Redcarpet::Render::HTML
    attr_accessor :ops, :log

    def initialize(options = {})
      super
      @ops = {}
      @ops.merge! options
      @log = Logger.new('log.txt')
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
      return header_string
    end
    def set_less_significant_to_zero(header_level)
      10.times {|i| p i+1}
    end
    def header(text, header_level)
      header_label = get_header_label(header_level)
      id = text.gsub(" ", "_")
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
  class MarkdownConverter
    attr_accessor :log, :ops, :markdown, :write_dir, :debug
    def initialize(options = {})
      @ops = {}
      @defaults = { :debug => false }
      unless options.nil?
        @defaults = @defaults.merge(options)
      end
      @ops = @defaults.merge(@ops)
      @debug = @ops[:debug]
      @log = Logger.new('log.txt')
      if level = @ops[:debug_level]
        @log.level = level
      else
        @log.level = Logger::DEBUG
      end
      @markdown = Redcarpet::Markdown.new(HTMLwithPygments,
                                          :fenced_code_blocks => true,
                                          :tables => true,
                                          :autolink => true,
                                          :with_toc_data => true)
    end
    def set_options(options = {})
      @ops = @ops.merge(options)
    end
    def to_markdown(content)
      return markdown.render(content)
    end
    def convert_markdown_file(dir, file)
      @log.debug "Converting file: #{file}"
      contents = File.open(dir + "/" + file, "r").read
      return convert_markdown_contents(contents)
    end
    def convert_markdown_contents(contents)
      contents = contents.remove_non_ascii
      html = @markdown.render(contents.force_encoding('US-ASCII'))
      return html
    end
    def get_out_file(file, write_dir)
      basename = File.basename(file, File.extname(file))
      @log.debug "Filename without extension: #{basename}"
      out_file = write_dir + "/" + basename + ".html"
      return out_file
    end
    def get_file_basename(file)
      basename = File.basename(file, File.extname(file))
    end

    def write_stylesheet(read_dir,write_dir)
      contents = File.open(read_dir + "/inputStyles.css", "rb").read
      css = Pygments.css
      File.open(write_dir + "/style.css", 'w') {|f| f.write(css + "\n" + contents) }
    end

    def modded_since_last_publish(src_file, write_file)
      src_file_ts = File.stat(src_file).mtime
      if not File.exist?(write_file)
        @log.debug "Target file doesn't exist, will copy source to dest: #{write_file}"
        return true
      end
      write_file_ts = File.stat(write_file).mtime
      @log.debug "[SRC]:#{src_file} - #{src_file_ts}"
      @log.debug "[DEST]:#{write_file} - #{write_file_ts}"

      # should return true or false depending on modification times...
      if write_file_ts > src_file_ts
        @log.debug "Source file older than output file, no need to regenerate."
        return false
      else
        @log.debug "Source file more recent than output file, need to regenerate."
        return true
      end
    end

    def modified_since_last_publish(read_dir, file, write_dir)
      basename = File.basename(file, File.extname(file))
      write_file = write_dir + "/" + basename + ".html"
      src_file = read_dir + "/" + file
      return modded_since_last_publish src_file, write_file
    end

    def get_files_to_process(doc_dir, write_dir)
      @log.debug "Begin processing directory: " + doc_dir
      Dir.chdir(doc_dir)
      all_mmd_files = []
      files_to_process = []
      Dir.foreach(doc_dir) do |file|
        $last_header_level = 0
        $last_header_count = 0
        $header = Array.new
        0.upto(6) { |i| $header[i] = 0 }
        convertedFile = false
        if file == ".." or file == "."
          @log.debug "Current entry is: #{file}, do nothing."
          next;
        end
        if file.match(/^\.#/)
          @log.debug "Do not process files that begin with .#.  Filename: #{file}"
          next;
        end
        if File.stat(doc_dir + "/" + file).directory?
          @log.debug "#{file} is a directory, skip it."
          next;
        end
        if File.extname(file) == ".mmd"
          @log.debug "Found MultiMarkdown file: #{file}"
          if modified_since_last_publish(doc_dir, file, write_dir)
            files_to_process.push file
          end
          all_mmd_files.push(file);
          next
        end
        @log.debug "File: #{file} is not a known format, skipping."
      end
      return files_to_process, all_mmd_files
    end
    def process_files(files_to_process, read_from_dir, write_dirs)
      @log.debug write_dirs.inspect
      @log.debug "files to process are:"
      @log.debug files_to_process.inspect
      @log.debug "number of files to process is: " + files_to_process.length.to_s
      files_to_process.each do |file|
        @log.debug "Current file is:"
        @log.debug file.inspect
        process_file file, read_from_dir, write_dirs
      end
    end
    def process_file(file, read_dir, write_dirs) 
      @log.debug "Found file: " 
      @log.debug read_dir.inspect
      @log.debug file.inspect
      indexer_dir = write_dirs[:for_indexer_dir]
      static_site_dir = write_dirs[:for_static_files_dir]
      indexer_file_path = get_out_file(file, indexer_dir)
      static_file_path = get_out_file(file, static_site_dir)
      html = convert_markdown_file(read_dir, file) 
      write_contents_no_style(indexer_file_path, html)
      write_contents_add_style(static_file_path,html)
      send_to_indexer(indexer_file_path, html)
    end
    def send_to_indexer(file_path, html)
      uploader = Solr::Upload.new(:solr_base_url => ops[:indexer_url])
      file_name = get_file_basename(file_path)
      uploader.upload_file( file_name, html, file_name )
    end
    def write_contents_no_style(out_file, html)
      @log.debug "Writing file: #{out_file}"
      File.open(out_file, 'w') {|f| f.write(html) }
    end
    def write_contents_add_style(out_file, html)
      @log.debug "Writing file: #{out_file}"
      style_info = '<head><LINK REL=StyleSheet HREF="style.css" TYPE="text/css"/></head>'
      @log.debug "Writing html + style info to file: " + out_file
      File.open(out_file, 'w') {|f| f.write(style_info + html) }
    end
    def create_index(index, write_dir)
      index.sort! { |a,b| a.downcase <=> b.downcase }
      file = File.open(write_dir + "/" +"index.html", 'w')
      file.write("<html><body><ul>")
      index.each { |filename|
        basename = File.basename(filename, File.extname(filename))
        file.write("<li/><a href=\"#{basename}.html\">#{basename}")
      }
      file.write("</ul></body></html>")
      file.close()
    end
    def copy_search_files(from,to) 
      files = [ "search.html", "search.js", "ajax-loader.gif", "help.png" ]
      files.each do |file|
        FileUtils.cp from + "/" + file, to
      end
    end
    def copy_images_dir(read_dir, write_dirs)
      src_dir = read_dir + "/images/"
      if not Dir.exists? src_dir
        @log.debug "No images directory found."
        return
      end
      @log.debug "Found images directory, will copy over now."
      write_dirs.each do |write_dir|
        files = Dir.glob(src_dir + '/*')
        files.each do |file|
          write_file = write_dir + "/" + (File.basename file).to_s
          if modded_since_last_publish(file, write_file)
            @log.debug "Copying image: " + file
            FileUtils.cp_r file, write_dir
          end
        end
      end
    end

    def go()
      before = Time.now

      read_dir = "/home/fenton/projects/documentation"
      write_dir = "/home/fenton/bin/website/"
      write_dir_static = "/home/fenton/bin/website_static"

      files_to_process, all_mmd_files = get_files_to_process read_dir, write_dir
      create_index all_mmd_files, write_dir_static
      process_files files_to_process, read_dir, :for_indexer_dir => write_dir, :for_static_files_dir => write_dir_static
      copy_images_dir read_dir, [write_dir,write_dir_static]
      copy_search_files read_dir, write_dir
      write_stylesheet read_dir, write_dir
      write_stylesheet read_dir, write_dir_static

      read_dir = "/home/fenton/projects/work-doco/docs"
      write_dir = "/home/fenton/bin/work-doco/"
      write_dir_static = "/home/fenton/bin/work-doco_static/"

      files_to_process, all_mmd_files = get_files_to_process read_dir, write_dir
      write_dirs = {
        :for_indexer_dir => write_dir, 
        :for_static_files_dir => write_dir_static }
      process_files files_to_process, read_dir, write_dirs
      copy_images_dir read_dir, [write_dir,write_dir_static]
      write_stylesheet read_dir, write_dir
      write_stylesheet read_dir, write_dir_static
      @log.debug "Elapsed time: #{Time.now - before}(s)"
    end
  end
end
