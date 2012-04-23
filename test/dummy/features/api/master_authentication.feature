Feature: Authentication Testing
  The web service provides a way to test authentication.
  
  Scenario: When I post a request as JSON with valid authentication credentials, then the app will say I am authorized.
    Given I am authenticated
    Given I have master permissions
    When I perform a GET to "/help/master_authentication" as JSON
    Then the HTTP status code should be "200"
    And the response at index 0 of the JSON response data should be "authorized"

  Scenario: When I post a request as XML with valid authentication credentials, then the app will say I am authorized.
    Given I am authenticated
    Given I have master permissions
    When I perform a GET to "/help/master_authentication" as XML
    Then the HTTP status code should be "200"
    And the response at index 0 of the XML response data should be "authorized"

  Scenario: When I post a request as HTTP with valid authentication credentials, then the app will say I am authorized.
    Given I am authenticated
    Given I have master permissions
    When I perform a GET to "/help/master_authentication" as HTTP
    Then the HTTP status code should be "200"
    And the response at index 0 of the JSON response data should be "authorized"
