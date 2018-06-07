Rails.application.routes.draw do
  get 'home/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :movies, only: [:index, :show]
  resources :reviews, except: [:edit, :update]

  get 'about' => 'about#index'
  get 'ratings' => 'ratings#index'
  root 'home#index'
end
