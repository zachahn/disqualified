# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v0.3.0 - 2023-04-16

### Added

* Lots of extra speed and efficiency

### Changed

* Yield additional context as the second argument `on_error`
* Change the existing migration to be of `ActiveRecord::Migration[7.0]`

## v0.2.0 - 2022-08-17

### Added

* Support for ActiveJob

### Fixed

* Note that the gem `concurrent-ruby` is a requirement
* Use `Rails.application.reloader` instead of the executor

## v0.1.1 - 2022-07-17

### Fixed

* Booting when installed from Rubygems

## v0.1.0 - 2022-07-17

### Added

* Make it kinda work
* An installation generator `bin/rails g disqualified:install`
