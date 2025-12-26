require "tmpdir"
require "tempfile"
require "spider-src"
require "spider-node/version"
require "spider-node/compile_result"
require "open3"

module Spider
  module Node
    class << self

      def spider_version
        Spider::Src.version
      end


      def spiderc(*args)
        cmd = [node, Spider::Src.js_path.to_s, *args]

        Open3.popen3(*cmd) do |stdin, stdout, stderr, wait_thr|
          stdin.close
          [wait_thr.value, stdout.read, stderr.read]
        end
      end

      def compile_file(source_file, *spiderc_options)
        
        target = File.basename source_file, '.spider'
        target_dir = File.dirname source_file

        Dir.mktmpdir do |output_dir|
          output_file = File.join(target_dir, target + '.js')
          exit_status, stdout, stderr = spiderc(*spiderc_options, '-c', source_file)

          output_js = File.exists?(output_file) ? File.read(output_file) : nil

          CompileResult.new(
              output_js,
              exit_status,
              stdout,
              stderr,
          )
        end
      end

    def compile(source, *spiderc_options)
      js_file = Tempfile.new(["spider-node", ".spider"])
      begin
        js_file.write(source)
        js_file.close
        result = compile_file(js_file.path, *spiderc_options)

        if result.success?
          result.js
        else
          raise result.stderr
        end
      ensure
        js_file.unlink
      end
    end

    def node
       ENV["TS_NODE"] || "node"
    end

    def locate_executable(cmd)
       if RbConfig::CONFIG["host_os"] =~ /mswin|mingw/ && File.extname(cmd) == ""
         cmd << ".exe"
       end

       if File.executable? cmd
         cmd
       else
         path = ENV['PATH'].split(File::PATH_SEPARATOR).find { |p|
           full_path = File.join(p, cmd)
           File.executable?(full_path) && File.file?(full_path)
         }
         path && File.expand_path(cmd, path)
       end
     end

      def check_node
        unless locate_executable(node)
          raise "spider-node requires node command, but it's not found. Please install it. " +
              "Set TS_NODE environmental variable If you want to use node command in non-standard path."
        end
      end
    end
  end
end

Spider::Node.check_node
