module ActiveApplication
  module BootstrapHelper
    def tab(name, id, active = false)
      classes = active ? ["tab", "active"] : ["tab"]
      content_tag(:li, link_to(name, "##{id}", "data-toggle" => "tab"), class: classes)
    end
  end
end
