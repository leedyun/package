# frozen_string_literal: true

require 'omniauth'
require 'omniauth/multipassword/base'

module OmniAuth
  module Strategies
    class MultiPassword
      include OmniAuth::Strategy
      include OmniAuth::MultiPassword::Base

      def initialize(app, *args, &block)
        super(app, *args) do
          # Do pass an empty block, as otherwise the captured block would be
          # passed to `super`, but this needs to be evaluate inside this
          # middleware, not omniauth's Rack builder instance.
        end

        if block.arity.zero?
          instance_eval(&block)
        else
          yield self
        end
      end

      def options
        yield @options if block_given?
        @options
      end

      def authenticator(klass, *args, &block)
        unless klass.is_a?(Class)
          begin
            klass = OmniAuth::Strategies.const_get(OmniAuth::Utils.camelize(klass.to_s).to_s)
          rescue NameError
            raise LoadError.new("Could not find matching strategy for #{klass.inspect}." \
                                "You may need to install an additional gem (such as omniauth-#{klass}).")
          end
        end

        args << block if block
        @authenticators ||= []
        @authenticators  << [klass, args]
      end

      def callback_phase
        username = request.params[username_id.to_s].to_s
        password = request.params[password_id.to_s].to_s
        if authenticate(username, password)
          super
        else
          fail!(:invalid_credentials)
        end
      end

      def authenticate(username, password)
        @authenticators.each do |auth|
          begin
            @authenticator = auth[0].new @app, *auth[1]
            @authenticator.init_authenticator(@request, @env, username)
            return true if @authenticator.authenticate(username, password)
          rescue Error => e
            OmniAuth.logger.warn "OmniAuth ERR >>> #{e}"
          end
          @authenticator = nil
        end
        false
      end

      def name
        return @authenticator.name if @authenticator

        super
      end

      info do
        info = @authenticator.info if @authenticator
        info = {} unless info.is_a?(Hash)
        info
      end
    end
  end
end
