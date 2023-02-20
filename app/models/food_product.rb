class FoodProduct < ApplicationRecord
  validates_presence_of :name, :manufacturer, :data_valid_at
  validates_numericality_of :energy_kilojoules_per_100_grams, greater_than: 0.0, 
    unless: Proc.new { |p| p.energy_kilojoules_per_100_grams.nil? }


  def self.import_from_xml(file)
    doc = Nokogiri::XML.parse(file)
    root_node = doc.xpath("//Product").first
    raise Nokogiri::XML::SyntaxError.new('Bad XML!') if doc.errors.any? || root_node.nil?

    product = self.new({
      name: doc.xpath("//Identity//DiagnosticDescription").text,
      manufacturer: doc.xpath("//Identity//Subscription").text,
      data_valid_at: root_node["VersionDateTime"].present? ? DateTime.parse(root_node["VersionDateTime"]) : nil
    })
    return product unless product.valid?

    product.parse_macros_from_doc(doc)
    product
  end

  def parse_macros_from_doc(doc)
    self.energy_kilojoules_per_100_grams = parse_energy_per_100_grams_from_doc(doc)
  end

  def parse_energy_per_100_grams_from_doc(doc)
    energy_text = doc.xpath("//Nutrient//Values//Value").first.text.downcase
    kj_index = energy_text.index("kj")

    energy_text[0, kj_index].strip
  end
end

