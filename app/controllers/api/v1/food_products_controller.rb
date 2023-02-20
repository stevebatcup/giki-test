class Api::V1::FoodProductsController < ActionController::API
  before_action { request.format = :json }

  def index
    @food_products = FoodProduct.order(name: :asc)
  end
end