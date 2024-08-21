Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :loans
  root 'users#home_page'
  get "up" => "rails/health#show", as: :rails_health_check

  get '/loans'   => 'loans#index',   as: 'get_user_loan'
  post '/loans'  => 'loans#create',  as: 'create_user_loan'

  # Defines the root path route ("/")
  # root "posts#index"
end
