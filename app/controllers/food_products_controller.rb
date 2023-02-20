class FoodProductsController < ApplicationController
  before_action :set_default_food_product

  def new; end

  def create
    if params[:file].present? 
      product = FoodProduct.import_from_xml(params[:file])
      if product.save
        flash[:success] = "Food Product Imported"
      else
        flash[:error] = "#{invalid_xml_msg}: #{product.errors.full_messages.first}"
      end
    else
      flash[:error] = "Please make sure to upload an XML file"
    end
    
    redirect_to new_food_product_path
  rescue Nokogiri::XML::SyntaxError => e
    flash[:error] = "#{invalid_xml_msg}: #{e.message}"
    return redirect_to new_food_product_path
  end

  private 

  def set_default_food_product
    @food_product = FoodProduct.new
  end

  def invalid_xml_msg
    "Please make sure your XML file is valid"
  end
end
