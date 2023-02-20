class FoodProductsController < ApplicationController
  before_action :set_default_food_product

  def new; end

  def create
    unless params[:file].present? 
      flash[:error] = "Please make sure to upload an XML file"
      return redirect_to new_food_product_path
    end
    
    foo

  end

  private 

  def set_default_food_product
    @food_product = FoodProduct.new
  end

end
