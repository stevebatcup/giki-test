Rails.application.routes.draw do

  resources :food_products, only: [:new, :create]
  namespace :api do
    namespace :v1 do
      get "food_products", to: 'food_products#index'
      get "food_product_descriptions", to: 'food_products#index', desc_only: true
    end
  end
  
  root "food_products#new"
end
