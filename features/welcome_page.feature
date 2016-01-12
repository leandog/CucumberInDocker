Feature: Newly generated rails application welcomes users
    As a Ruby on Rails developer 
    There should be a default welcome page for a new Rails application
    So that I can confirm that my site is working
 
    Scenario: The Welcome Page presents welcome message
        Given I am on the Welcome Page
        Then I should see the title "Ruby on Rails: Welcome aboard"