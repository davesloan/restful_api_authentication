# Change History / Release Notes

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