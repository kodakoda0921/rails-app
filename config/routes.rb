Rails.application.routes.draw do
  get 'password_resets/edit'
  get 'password_resets/new'
  root 'users#home'
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
