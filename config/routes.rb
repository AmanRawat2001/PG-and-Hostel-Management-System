Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    resources :hostels, except: [:edit] do
      resources :rooms, only: [:index, :create]
    end

    resources :rooms, only: [:update, :destroy] do
      resources :bookings, only: [:create]
    end
    resources :bookings, only: [:index, :destroy] do
      member do
        put :approve
        put :reject
      end
    end

    post "/users/login" => "authentication#login"
    post "/users/signup" => "authentication#signup"
  end
end
