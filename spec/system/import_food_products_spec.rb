require "rails_helper"

RSpec.describe "Import Food Products", type: :system, js: true do
  before :each do
    visit new_food_product_url
  end

  scenario "shows the import XML form" do
    expect(page).to have_content "Upload a food product data file"
    expect(page).to have_selector("input[value='Upload']")
  end

  xscenario "submits the import XML form with valid data and returns a success message" do
  end

  scenario "submits the import XML form without uploading a file and returns an error message" do
    page.find("input[value='Upload']").click
    expect(page).to have_content "Please make sure to upload an XML file"
  end

  xscenario "submits the import XML form with invalid data and returns an error message" do
  end
end