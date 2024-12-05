Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  
  root to: 'homes#top'
  get "home/about"=>"homes#about"
  get "search" => "searches#search"


  resources :users, only: [:index,:show,:edit,:update] do
    get "posts_on_date" => "users#posts_on_date"
    
    resource :relationships, only: [:create, :destroy]
  	  get "followings" => "relationships#followings", as: "followings"
  	  get "followers" => "relationships#followers", as: "followers"
  end
  
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create,:destroy]
    resource :favorite, only: [:create, :destroy]
  end

  resources :messages, only: [:show, :create, :destroy]
  resources :rooms, only: [:create, :show]

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  
  
end