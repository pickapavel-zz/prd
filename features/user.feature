Feature: User
  In order to cover authentication & co
  I want to be able to login

  Scenario: Login
    Given I enter login page
    And I fill email with wrong password
    Then I should be informed that login went wrong
    When I fill correct email and password double
    Then I should be logged in
