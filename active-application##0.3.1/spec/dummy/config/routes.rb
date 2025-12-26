Dummy::Application.routes.draw do
  resources :milestones do
    resources :tasks
  end

  resources :projects do
    resources :milestones
    resources :tasks
  end

  active_application_routes
end
