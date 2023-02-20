require "capybara/rails"
require "capybara/rspec"

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument "--headless"
  options.add_argument "--disable-popup-blocking"
  options.add_argument "--chrome"

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium_chrome_headless
    Capybara.server = :puma, {Silent: true}
    Capybara.default_max_wait_time = 5
    Capybara.always_include_port = true
  end
end
