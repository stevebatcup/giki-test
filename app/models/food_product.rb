class FoodProduct < ApplicationRecord
  include Importable

  validates_presence_of :name, :manufacturer

  def energy_kilocalories_per_100_grams
    (energy_kilojoules_per_100_grams * 0.239006).round(2)
  end
end

