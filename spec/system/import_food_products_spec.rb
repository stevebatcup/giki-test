require "rails_helper"

RSpec.describe "Import Food Products", type: :system, js: true do
  before :each do
    visit new_food_product_url
  end

  scenario "shows the import XML form" do
    expect(page).to have_content "Upload a food product data file"
    expect(page).to have_selector("input[value='Upload']")
  end

  context "validation" do
    scenario "submits the import XML form without uploading a file and returns an error message" do
      submit_form

      expect(page).to have_content "Please make sure to upload an XML file"
    end

    scenario "submits the import XML form that is missing the correct data and returns an error message" do
      attach_file('file', File.expand_path('spec/support/invalid_food_product_wrong_nodes.xml'))
      submit_form

      expect(page).to have_content "Please make sure your XML file is valid: Name can't be blank"
    end

    scenario "submits the import XML form with invalid XML and returns an error message" do
      attach_file('file', File.expand_path('spec/support/invalid_food_product_bad_xml.xml'))
      submit_form

      expect(page).to have_content "Please make sure your XML file is valid: Bad XML!"
    end
  end

  scenario "submits the import XML form with valid data and returns a success message" do
    attach_file('file', File.expand_path("spec/support/valid_food_product_#{(1..3).to_a.sample}.xml"))
    submit_form

    expect(page).to have_content "Food Product Imported"
  end


  def submit_form
    page.find("input[value='Upload']").click
  end
end