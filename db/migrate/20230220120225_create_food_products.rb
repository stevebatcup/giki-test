class CreateFoodProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :food_products do |t|
      t.string :name
      t.string :manufacturer
      t.text :description
      t.string :categories
      t.float :energy_kilojoules_per_100_grams, default: nil
      t.float :fat_grams_per_100_grams, default: nil
      t.float :saturates_grams_per_100_grams, default: nil
      t.float :carbohydrate_grams_per_100_grams, default: nil
      t.float :sugars_grams_per_100_grams, default: nil
      t.float :protein_grams_per_100_grams, default: nil
      t.float :salt_grams_per_100_grams, default: nil
      t.json :data, default: {}
      t.datetime :data_valid_at

      t.timestamps
    end
  end
end
