Rails.application.routes.draw do
  root 'users#home'
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :account_activations, only: [:edit]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
