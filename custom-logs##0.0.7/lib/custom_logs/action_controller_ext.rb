module CustomLogs
  module ActionControllerExt

    protected

    def custom_logs

      original_params = get_original_params
      #original_flash = get_original_flash

      yield

      begin
        logs = {
            controller: params[:controller],
            action: params[:action],
            current: try_current_user_email,
            path: request.path,
            params: original_params
            #flash: original_flash,
            #response_code: response.status,
            #response_message: response.message
        }

        if request.xhr?
          logs[:ajax] = ajax_attributes
        end

        CustomLogs::Logger.write(logs)
      rescue
        Rails.logger.info "[CUSTOM LOGS NOT SAVED]: #{logs.to_json}"
      end


    end

    def get_original_params
      path_params = request.path_parameters
      request.params.clone.except(:controller, :action)
    end

    def get_original_flash
      request.flash.clone
    end

    def try_current_user_email
      current = nil
      ParseConfig.get[:user_methods].each do |user_method|
        current = {:"#{user_method.gsub('current_', '')}" => send(user_method).email} rescue nil
        break if current
      end
      current
    end

    def ajax_attributes
      begin
        {referer: URI::parse(request.headers["HTTP_REFERER"]).path}
      rescue
        {}
      end
    end

  end
end