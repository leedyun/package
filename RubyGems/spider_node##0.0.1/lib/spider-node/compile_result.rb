# coding: utf-8

module Spider
  module Node
    class CompileResult
      
      def initialize(js, exit_status, stdout, stderr)
        @js = js
        @exit_status = exit_status
        @stdout = stdout
        @stderr = stderr
      end

      attr_reader :js, :source_map, :exit_status, :stdout, :stderr

      def success?
        @exit_status == 0
      end

    end
  end
end