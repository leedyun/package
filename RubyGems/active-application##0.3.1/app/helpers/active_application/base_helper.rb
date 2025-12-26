module ActiveApplication
  module BaseHelper
    def application_name
      I18n.t("active_application.application_name", default: "Active Application")
    end
  end
end
