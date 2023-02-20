require 'rails_helper'

RSpec.describe FoodProduct, type: :model do
  let(:xml_file_contents) { File.read(File.expand_path('spec/support/valid_food_product_1.xml')) }
  let(:xml_doc) { Nokogiri::Slop(xml_file_contents) }

  it "imports a valid product from a valid xml file" do
    product = subject.class.import_from_xml(xml_file_contents)
    expect(product.valid?).to be_truthy
    expect(product.name).to eq "Ombar Blueberry and Acai 35g"
    expect(product.manufacturer).to eq "Tree of Life UK Ltd"
    expect(product.energy_kilojoules_per_100_grams).to eq 2420.0
    expect(product.fat_grams_per_100_grams).to eq 44.0
  end

  it "correctly parses energy in kilojoules from the xml" do
    kj = subject.parse_energy_per_100_grams_from_doc(xml_doc).to_f
    expect(kj).to eq 2420.0
  end

  it 'correctly parses fat in grams from the xml' do
    fat = subject.parse_fat_per_100_grams_from_doc(xml_doc).to_f
    expect(fat).to eq 44.0
  end

  it 'correctly parses saturates in grams from the xml' do
    saturates = subject.parse_saturates_per_100_grams_from_doc(xml_doc).to_f
    expect(saturates).to eq 26.0
  end

  it 'correctly parses carbohydrate in grams from the xml' do
    carbohydrate = subject.parse_carbohydrate_per_100_grams_from_doc(xml_doc).to_f
    expect(carbohydrate).to eq 44.0
  end

  it 'correctly parses sugars in grams from the xml' do
    sugars = subject.parse_sugars_per_100_grams_from_doc(xml_doc).to_f
    expect(sugars).to eq 28.0
  end

  it 'correctly parses protein in grams from the xml' do
    protein = subject.parse_protein_per_100_grams_from_doc(xml_doc).to_f
    expect(protein).to eq 7.5
  end

  it 'correctly parses salt in grams from the xml' do
    salt = subject.parse_salt_per_100_grams_from_doc(xml_doc).to_f
    expect(salt).to eq 0.1
  end

  it 'correctly parses and formats the categories' do
    subject.build_categories_from_doc(xml_doc)
    expect(subject.categories).to eq "Grocery > Confectionery > Block Chocolate Bars"
  end

  it 'correctly parses and formats the description' do
    future_date = 2.months.from_now
    subject.name = "Awesome Chocs"
    subject.manufacturer = "Mr. Kipling"
    subject.data_valid_at = future_date
    subject.build_description_from_doc(xml_doc)

    expect(subject.description).to eq "Product data for Awesome Chocs by Mr. Kipling as of #{future_date.strftime("%H:%I on %B %d, %Y")}"
  end
end
