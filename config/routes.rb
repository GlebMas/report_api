Rails.application.routes.draw do
  get 'comments/create'

  devise_for :users
  root "reports#new"
  resources :reports, only: [:new, :create, :index, :show]
  resources :comments, only: [:create]

  namespace :api do
    resources :reports, only: [:show, :index]
  end
end
