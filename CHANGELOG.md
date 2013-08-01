# Change History / Release Notes

## Version 0.2.4
* Closed Issue #7 - Option to use a different ActiveRecord class than RestClient
* This update involves a lot of changes to a lot of files, but the functionality remains the same. The change was to rename RestClient to RestAppClient and rest_client to rest_client. This avoids a conflict with the popular rest-client gem that uses the same RestClient class name.

## Version 0.2.3
* Update checker.rb to automatically lowercase hashes for crypto lib compatibility
* Closed Issue #6 - Wrong request_uri in README's client example

## Version 0.2.2
* Closed Issue #5 - Improperly formatted timestamps result in an uncaught exception

## Version 0.2.1

* Closed Issue #3 - Failing to define an environment in the YML causes a fatal error
* Closed Issue #4 - Changes to the request_window in the YML were ignored in favor of the default 4 minute window

## Version 0.2.0

* Added verbose error messaging; if this is enabled in the YML config file, then the response to an authentication failure will be more descriptive as to why the authentication failed. To enable, add `verbose_errors: true` to the `config/restful_api_authentication.yml`.

## Version 0.1.2

* Resolved Issue #2: UUID gem is not required and therefore throws an error when this gem is used.
* Added some documentation on how to use the master authentication.
* Updated change history / release notes.

## Version 0.1.1

* Resolved Issue #1: Using authenticated_master? in before filter results in an error

## Version 0.1.0

* Initial release. See README.md for details.