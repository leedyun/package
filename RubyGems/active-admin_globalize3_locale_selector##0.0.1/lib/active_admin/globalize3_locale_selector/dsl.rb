module ActiveAdmin
  module Globalize3LocaleSelector
    module DSL

      def change_globalize3_locale(options={})
        as = options[:as] || 'sidebar'
        as = as.to_s

        controller do
          around_filter :force_globalize_locale

          def force_globalize_locale
            if params[:with_locale].present?
              Globalize.with_locale(params[:with_locale]) do
                yield
              end
            else
              yield
            end
          end
        end

        if as == 'action_item'
          action_item options do
            render :partial => 'globalize3_locale_selector/action_item_form'
          end
        else
          sidebar :show_with_locale, options do
            render :partial => 'globalize3_locale_selector/sidebar_form'
          end
        end

      end

    end
  end
end
