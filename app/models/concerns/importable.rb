module Importable
  extend ActiveSupport::Concern

  included do
    validates_presence_of :data_valid_at
    validates_numericality_of :energy_kilojoules_per_100_grams, greater_than: 0.0, 
      unless: Proc.new { |p| p.energy_kilojoules_per_100_grams.nil? }
  end

  class_methods do
    def import_from_xml(file_contents)
      doc = Nokogiri::Slop(file_contents)
      product_root_node = doc.Product
      raise Nokogiri::XML::SyntaxError.new('Bad XML!') if doc.errors.any? || product_root_node.nil?

      product = self.new({
        name: doc.xpath("//Identity//DiagnosticDescription").text,
        manufacturer: doc.xpath("//Identity//Subscription").text,
        data: Hash.from_xml(doc.to_xml).to_json,
        data_valid_at: product_root_node["VersionDateTime"].present? ? DateTime.parse(product_root_node["VersionDateTime"]) : nil
      })
      return product unless product.valid?

      product.calculate_macros_from_doc(doc)
      product.get_categories_from_doc!(doc)
      product
    end
  end

  def calculate_macros_from_doc(doc)
    self.energy_kilojoules_per_100_grams = parse_energy_per_100_grams_from_doc(doc)
    self.fat_grams_per_100_grams = parse_fat_per_100_grams_from_doc(doc)
    self.saturates_grams_per_100_grams = parse_saturates_per_100_grams_from_doc(doc)
    self.carbohydrate_grams_per_100_grams = parse_carbohydrate_per_100_grams_from_doc(doc)
    self.sugars_grams_per_100_grams = parse_sugars_per_100_grams_from_doc(doc)
    self.protein_grams_per_100_grams = parse_protein_per_100_grams_from_doc(doc)
    self.salt_grams_per_100_grams = parse_salt_per_100_grams_from_doc(doc)
  end

  def parse_energy_per_100_grams_from_doc(doc)
    numeric_nutrition_node(doc).NutrientValues("[@Name='Energy (kJ)']").Per100.Value.text
  end

  def parse_fat_per_100_grams_from_doc(doc)
    numeric_nutrition_node(doc).NutrientValues("[@Name='Fat (g)']").Per100.Value.text
  end

  def parse_saturates_per_100_grams_from_doc(doc)
    numeric_nutrition_node(doc).NutrientValues("[@Name=' of which saturates (g)']").Per100.Value.text
  end

  def parse_carbohydrate_per_100_grams_from_doc(doc)
    numeric_nutrition_node(doc).NutrientValues("[@Name='Carbohydrate (g)']").Per100.Value.text
  end

  def parse_sugars_per_100_grams_from_doc(doc)
    numeric_nutrition_node(doc).NutrientValues("[@Name=' of which sugars (g)']").Per100.Value.text
  end

  def parse_protein_per_100_grams_from_doc(doc)
    numeric_nutrition_node(doc).NutrientValues("[@Name='Protein (g)']").Per100.Value.text
  end

  def parse_salt_per_100_grams_from_doc(doc)
    numeric_nutrition_node(doc).NutrientValues("[@Name='Salt (g)']").Per100.Value.text
  end

  def get_categories_from_doc!(doc)
    categories = []
    category_level_nodes = doc.Product.Data.Language.Categorisations.Categorisation.Level
    category_level_nodes.each { |c| categories << c.text }

    self.categories = categories.join(" > ")
  end

  private

  def numeric_nutrition_node(doc)
    doc.Product.Data.Language.ItemTypeGroup.NumericNutrition
  end
end