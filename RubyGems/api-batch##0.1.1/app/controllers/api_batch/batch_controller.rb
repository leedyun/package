require 'rails'

module ApiBatch
  class BatchController < ActionController::Base

    def get

      response = []

      request = params[:paths]
      request.each do |r|

        request_params = Rails.application.routes.recognize_path(r, :method => :get)
        controller = "#{request_params[:controller].camelcase}Controller".constantize.new
        controller.action_name = request_params[:action]
        controller.request = ActionDispatch::Request.new('rack.input' => [])
        controller.request.path_parameters = request_params.with_indifferent_access
        controller.response = ActionDispatch::Response.new
        controller.send request_params[:action]
        result = JSON.load(controller.response.body)

        response.push(result)

      end

      render :json => response

    end

  end
end