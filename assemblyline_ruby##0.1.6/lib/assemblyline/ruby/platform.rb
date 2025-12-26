module Assemblyline
  module Ruby
    class Platform
      def initialize(path = "/etc/os-release")
        release = Hash[
                  File.read(path)
                  .tr("\"", "")
                  .split("\n").map { |row| row.split("=") }
        ]
        @id = release["ID"]
        @like = release["ID_LIKE"]
        @version = release["VERSION_ID"]
        @pretty = release["PRETTY_NAME"]
      end

      attr_reader :id, :version, :like

      def to_s
        @pretty
      end
    end
  end
end
