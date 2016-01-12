Given(/^I am on the Welcome Page$/) do
  Capybara.current_driver = :selenium
  visit('http://localhost:3000')
end

Then(/^I should see the title "(.*?)"$/) do |message|
  fail unless page.has_title? message
end