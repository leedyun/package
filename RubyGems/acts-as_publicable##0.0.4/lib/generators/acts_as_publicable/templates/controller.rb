class <%= name.camelize %>Controller < ApplicationController

    def publish
        @model = params[:type].classify.constantize.find(params[:id])
        @model.publish!
        redirect_to params[:url] || @model, :notice => I18n.t("helpers.#{params[:type]}.publish_message")
    end

    def unpublish
        @model = params[:type].classify.constantize.find(params[:id])
        @model.unpublish!
        redirect_to params[:url] || @model, :notice => I18n.t("helpers.#{params[:type]}.unpublish_message")
    end

end
