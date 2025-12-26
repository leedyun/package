module ActiveApplication
  module Routes
    def active_application_routes
      scope module: "active_application" do
        namespace :backend do
          resources :users 
          root to: "dashboard#index", as: :root
        end
      end

      devise_for :users, skip: [:sessions, :registrations]
      devise_scope :user do
        get "sign_in" => "devise/sessions#new", as: :new_user_session
        post "sign_in" => "devise/sessions#create", as: :user_session
        delete "sign_out" => "devise/sessions#destroy", as: :destroy_user_session
        get "sign_up" => "devise/registrations#new", as: :new_user_registration
        post "account" => "devise/registrations#create", as: :user_registration
        get "account" => "devise/registrations#edit", as: :edit_user_registration
        put "account" => "devise/registrations#update"

        get "confirm/:confirmation_token" => "devise/confirmations#show", as: :user_confirmation

        get "forgot" => "devise/passwords#new", as: :new_user_password
        post "reset" => "devise/passwords#create", as: :user_password
        get "reset/:reset_password_token" => "devise/passwords#edit", as: :edit_user_password
        put "reset" => "devise/passwords#update"
      end
      
      root to: "active_application/public#index"
    end
  end
end
