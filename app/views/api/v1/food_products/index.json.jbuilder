json.array! @food_products do |food_product|
  unless params[:desc_only].present?
    json.name food_product.name
    json.manufacturer food_product.manufacturer
    json.categories food_product.categories
    json.kilojoules_per_100_g "#{food_product.energy_kilojoules_per_100_grams.to_i}kj"
    json.kilocalories_per_100_g "#{food_product.energy_kilocalories_per_100_grams.to_i}kcal"
    json.fat_per_100_g "#{food_product.fat_grams_per_100_grams}g"
    json.saturates_per_100_g "#{food_product.saturates_grams_per_100_grams}g"
    json.carbohydrate_per_100_g "#{food_product.carbohydrate_grams_per_100_grams}g"
    json.sugars_per_100_g "#{food_product.sugars_grams_per_100_grams}g"
    json.protein_per_100_g "#{food_product.protein_grams_per_100_grams}g"
    json.salt_per_100_g "#{food_product.salt_grams_per_100_grams}g"
  end

  json.description food_product.description
end
