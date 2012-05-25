Feature: Authentication Testing
  The web service provides a way to test authentication.
  
  Scenario: When I post a request as JSON with valid authentication credentials, then the app will say I am authorized.
    Given I am authenticated
    When I perform a GET to "/help/authentication" as JSON
    Then the HTTP status code should be "200"
    And the response at index 0 of the JSON response data should be "authorized"

  Scenario: When I post a request as XML with valid authentication credentials, then the app will say I am authorized.
    Given I am authenticated
    When I perform a GET to "/help/authentication" as XML
    Then the HTTP status code should be "200"
    And the response at index 0 of the XML response data should be "authorized"

  Scenario: When I post a request as HTTP with valid authentication credentials, then the app will say I am authorized.
    Given I am authenticated
    When I perform a GET to "/help/authentication" as HTTP
    Then the HTTP status code should be "200"
    And the response at index 0 of the JSON response data should be "authorized"
    
  Scenario: When I post a request with a timestamp that is too far in the past, then the app will say I am not authorized.
    Given a "rest_client" exists
    When I perform an authentication test with "old authentication data"
    Then the HTTP status code should be "401"
    And the response at index 0 of the JSON response data should be "request is outside the required time window of 4 minutes"

  Scenario: When I post a request with a timestamp that is too far in the future, then the app will say I am not authorized.
    Given a "rest_client" exists
    When I perform an authentication test with "future authentication data"
    Then the HTTP status code should be "401"
    And the response at index 0 of the JSON response data should be "request is outside the required time window of 4 minutes"

  Scenario: When I post a request with an unknown api key, then the app will say I am not authorized.
    Given a "rest_client" exists
    When I perform an authentication test with "unknown api key data"
    Then the HTTP status code should be "401"
    And the response at index 0 of the JSON response data should be "client is not registered"

  Scenario: When I post a request with an invalid secret, then the app will say I am not authorized.
    Given a "rest_client" exists
    When I perform an authentication test with "invalid secret data"
    Then the HTTP status code should be "401"
    And the response at index 0 of the JSON response data should be "signature is invalid"

  Scenario: When I post a request with an invalid request URI, then the app will say I am not authorized.
    Given a "rest_client" exists
    When I perform an authentication test with "invalid request uri data"
    Then the HTTP status code should be "401"
    And the response at index 0 of the JSON response data should be "signature is invalid"
