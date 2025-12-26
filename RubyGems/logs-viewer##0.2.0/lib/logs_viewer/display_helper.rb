module LogsViewer
  class DisplayHelper

    def self.get_nested_logs(list)
      html = "<ul style='list-style-type:none'>"
      list.each do |(item)|
        icon_file = '<i class="glyphicon glyphicon-file"></i>'
        icon_dir = '<i class="glyphicon glyphicon-folder-open"></i>'
        link = "<a href='/logs?file=#{item}&number_lines=#{LogsViewer::Config.number_lines}'>#{icon_file} #{item}</a>"
        html += (LogsViewer::Handler.is_file? item) ? "<li>#{link}": "<li>#{icon_dir} #{item}"
        html +="  #{self.get_nested_logs(LogsViewer::Handler.list(item))}" if LogsViewer::Handler.is_directory? item
        html +="</li>"
      end
      html += "</ul>"
      html
    end

  end
end