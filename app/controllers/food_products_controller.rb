class FoodProductsController < ApplicationController
  def new
    @food_product = FoodProduct.new
  end
end