require "rails_helper"

RSpec.describe "Import Food Products", type: :system, js: true do
  scenario "shows the import XML form" do
    visit new_food_product_url
    expect(page).to have_content "Upload a food product data file"
    expect(page).to have_selector("input[value='Upload']")
  end

  xscenario "submits the import XML form with valid data and returns a success message" do
  end

  xscenario "submits the import XML form with invalid data and returns an error message" do
  end
end