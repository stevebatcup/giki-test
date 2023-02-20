class FoodProduct < ApplicationRecord
  def self.import_from_xml(file)
    doc = Nokogiri::XML.parse(file)
    raise Nokogiri::XML::SyntaxError.new('Bad XML!') if doc.errors.any?

    product_name = doc.xpath("//Identity//DiagnosticDescription")
    manufacturer = doc.xpath("//Identity//Subscription")
    raise Nokogiri::XML::SyntaxError.new('Must contain valid data for a food product') if product_name.empty? || manufacturer.empty?
  end
end
