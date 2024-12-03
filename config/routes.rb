require 'sidekiq/web'
Rails.application.routes.draw do
  Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
    username == 'admin' && password == 'password'  # change this to your own credentials
  end
  mount Sidekiq::Web => '/sidekiq'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # Defines the root path route ("/")
  # root "posts#index"

  resources :readings, only: [:create, :show] do
    get :stat_data, on: :collection
  end
end
