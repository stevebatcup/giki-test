Rails.application.routes.draw do

  resources :food_products, only: [:new, :create]
  root "food_products#new"
end
