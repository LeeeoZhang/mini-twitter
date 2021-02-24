Rails.application.routes.draw do
  get 'relationships/create'
  get 'relationships/destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static_page#home'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:edit, :update, :create, :new]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  get '/help', to: 'static_page#help'
  get '/about', to: 'static_page#about'
  get '/contact', to: 'static_page#contact'
  get '/signup', to: 'users#new'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
