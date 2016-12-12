Feature: Planner
  In order to loan offering process
  As a bank user
  I want to have overview of existing loans and be able to create new one

  Scenario: Create new loan
    Given I'm on identification page
    When I enter existing company IČO and click Create
    # Then I should see page with company details

  Scenario: Get overview of existing loans
    Given some loans already exist
    When I enter planner
    # Then I should see all of them
