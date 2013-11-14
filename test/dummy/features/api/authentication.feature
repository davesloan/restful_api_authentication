Feature: Authentication Testing
  The web service provides a way to test authentication.

  @me
  Scenario: When I post a request as JSON with valid authentication credentials but the client is disabled, then the app will return an error message.
    Given I am authenticated
    And the rest client is disabled
    When I perform a GET to "/help/authentication" as JSON
    Then the HTTP status code should be "401"
    And the JSON response should be ["client is disabled"]

  Scenario: When I post a request as JSON that is outside the default 4 minute window but within posted 10 minute window, then the app will say I am authorized.
    Given a "rest_client" exists
    When I perform an authentication test with "outside default 4 minute window"
    Then the HTTP status code should be "200"
    And the response at index 0 of the JSON response data should be "authorized"
  
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

  Scenario: When I post a request as HTTP with valid authentication credentials and a capitalized SHA hash, then the app will say I am authorized.
    Given a "rest_client" exists
    When I perform an authentication test with "capitalized hash"
    Then the HTTP status code should be "200"
    And the response at index 0 of the JSON response data should be "authorized"
    
  Scenario: When I post a request with a timestamp that is too far in the past, then the app will say I am not authorized.
    Given a "rest_client" exists
    When I perform an authentication test with "old authentication data"
    Then the HTTP status code should be "401"
    And the response at index 0 of the JSON response data should be "request is outside the required time window of 10 minutes"

  Scenario: When I post a request with a timestamp that is too far in the future, then the app will say I am not authorized.
    Given a "rest_client" exists
    When I perform an authentication test with "future authentication data"
    Then the HTTP status code should be "401"
    And the response at index 0 of the JSON response data should be "request is outside the required time window of 10 minutes"

  Scenario: When I post a request with an unknown api key, then the app will say I am not authorized.
    Given a "rest_client" exists
    When I perform an authentication test with "unknown api key data"
    Then the HTTP status code should be "401"
    And the response at index 0 of the JSON response data should be "client is not registered"

  Scenario: When I post a request with an improperly formatted timestamp, then the app will say I am not authorized.
    Given a "rest_client" exists
    When I perform an authentication test with "improperly formatted timestamp"
    Then the HTTP status code should be "401"
    And the response at index 0 of the JSON response data should be "timestamp was in an invalid format; should be YYYY-MM-DD HH:MM:SS UTC"

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
