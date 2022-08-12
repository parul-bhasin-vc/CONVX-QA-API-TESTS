@Smoke
Feature: API tests for order-manager apis

  Scenario: testing the get Order Details API for existing order

    Given url 'https://internal.cdls.euwest1.staging.volvo.care/internal/ordermanager/v1/orders'
    And path 'adgfZjW1A9JR8A3IZffZYkvnEhkwvboxsmDCKM8ponCq5tq50iAXzxxKPKMN2AUr9UG4r0nlYUoWbEH9VINPg'
    When method GET
    Then status 200
    Then print response

  Scenario: testing the get Order Details API for non-existing order

    Given url 'https://internal.cdls.euwest1.staging.volvo.care/internal/ordermanager/v1/orders'
    And path 'adZjW1A9JR8A3IZffZYkvnEhkwvboxsmDCKM8ponCq5tq50iAXzxxKPKMN2AUr9UG4r0nlYUoWbEH9VINPg'
    When method GET
    Then status 404

  Scenario: testing the get call for Order Details with wrong params

    Given url 'https://internal.cdls.euwest1.staging.volvo.care/internal/ordermanager/v1/orders'
    And path ''
    When method GET
    Then status 405