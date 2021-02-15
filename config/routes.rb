Rails.application.routes.draw do
  get 'frame/show'
  get 'password_resets/edit'
  get 'password_resets/new'
  root 'frame#show'
  get 'users/home'
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :profiles, only: [:edit, :destroy]
  resources :post_comments, only: [:create, :destroy]
  resources :follow_relation, only: [:create, :destroy, :index]
  resources :search, only: [:new, :index]
  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
