Rails.application.routes.draw do
  

  get 'groups/new'
  get 'groups/index'
  get 'groups/show'
  get 'groups/edit'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  
  root to: 'homes#top'
  get "home/about"=>"homes#about"
  get "search" => "searches#search"
  get "events/index" =>"events#index"
  get "tag_searches/search" => "tag_searches#search"


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
  resources :notifications, only: [:update]
  resource :map, only: [:show]


  resources :groups, only: [:new, :index, :show, :create, :edit, :update] do
    resource :group_users, only: [:create, :destroy]
    resources :event_notices, only: [:new, :create]
    get "event_notices" => "event_notices#sent"
  end


  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  

  
  
end