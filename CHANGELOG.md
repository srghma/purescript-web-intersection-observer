# Changelog

Notable changes to this project are documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Breaking changes:

- module `Web.IntersectionObserverEntry` was split on `Web.IntersectionObserverEntry.Safe` and `Web.IntersectionObserverEntry.Unsafe`
- module `Web.IntersectionObserver` was split on `Web.IntersectionObserver.Safe` and `Web.IntersectionObserver.Unsafe`
- module `Web.IntersectionObserver` now exports everything that is needed
- more type safety using `Web.IntersectionObserver.Margin` and `Web.IntersectionObserver.Percentage`

New features:

Bugfixes:

Other improvements:

- added tests

## [v1.0.0](https://github.com/purescript-web/purescript-web-intersection-observer/releases/tag/v1.0.0) - 2022-06-08

Initial release. Compatible with PureScript 0.15.0
