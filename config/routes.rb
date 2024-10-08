require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  mount Sidekiq::Web => '/sidekiq'
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :loans do
    member do
      post :repay
    end
  end
  root 'users#home_page'
  get "up" => "rails/health#show", as: :rails_health_check

  get '/loans'   => 'loans#index',   as: 'get_user_loan'
  post '/loans'  => 'loans#create',  as: 'create_user_loan'
  get 'profile', to: 'users#profile', as: 'user_profile'
  put 'edit_profile', to: 'users#edit_profile', as: 'edit_profile'

  post '/approve_loan', to: 'loans#approve_loan', as: 'approve_loan'
  post '/reject_loan', to: 'loans#reject_loan', as: 'reject_loan'
  get '/show_change_logs', to: 'loans#show_change_logs', as: 'show_change_logs'
end
