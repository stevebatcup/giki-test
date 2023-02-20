class FoodProduct < ApplicationRecord
  include Importable

  validates_presence_of :name, :manufacturer
end

