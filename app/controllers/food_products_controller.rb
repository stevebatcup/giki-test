class FoodProductsController < ApplicationController
  before_action :set_default_food_product

  def new; end

  def create
    if params[:file].present? 
      FoodProduct.import_from_xml(params[:file])
      flash[:success] = "Food Product Imported"
    else
      flash[:error] = "Please make sure to upload an XML file"
    end
    redirect_to new_food_product_path
  rescue Nokogiri::XML::SyntaxError => e
    flash[:error] = "Please make sure your XML file is valid: #{e.message}"
    return redirect_to new_food_product_path
  end

  private 

  def set_default_food_product
    @food_product = FoodProduct.new
  end

end
