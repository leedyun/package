module ActiveApplication
  module LayoutHelper
    def layout_flash
      html = Array.new
      flash.each do |key, msg|
        case key.to_s
        when "alert"
          flash_class = "alert-error"
        when "notice"
          flash_class = "alert-info"
        else
          flash_class = key.to_s
        end
        html << content_tag(:div,
          msg.html_safe + ' <a class="close" href="#" data-dismiss="alert">&times;</a>'.html_safe,
          class: ["fade", "in", "alert", flash_class],
          "data-alert" => "alert"
        )
      end
      html.join.html_safe
    end
  end
end
