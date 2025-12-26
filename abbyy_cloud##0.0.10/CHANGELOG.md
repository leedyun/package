# [v0.0.10 2016-10-11](https://github.com/nepalez/abbyy-cloud/tree/v0.0.10)

### Internal

* Switched to `dry-initializer` gem v0.9.2+ (nepalez)

[Compare v0.0.9...v0.0.10](https://github.com/nepalez/abbyy-cloud/compare/v0.0.9...v0.0.10)

# [v0.0.9 2016-10-11](https://github.com/nepalez/abbyy-cloud/tree/v0.0.9)

### Internal

* Update dependency from the `dry-initializer` gem (nepalez)
* Switch from Dry::Struct to native ABBYY::Cloud::Model (nepalez)
* Drop dependency from `dry-struct` gem (nepalez)

[Compare v0.0.8...v0.0.9](https://github.com/nepalez/abbyy-cloud/compare/v0.0.8...v0.0.9)

# [v0.0.8 2016-09-17](https://github.com/nepalez/abbyy-cloud/tree/v0.0.8)

### Bugs Fixed

* Remove unnecessary arguments of submitted order (nepalez)

[Compare v0.0.7...v0.0.8](https://github.com/nepalez/abbyy-cloud/compare/v0.0.7...v0.0.8)

# [v0.0.7 2016-09-09](https://github.com/nepalez/abbyy-cloud/tree/v0.0.7)

### Bugs Fixed

* Order of loading files (nepalez)

[Compare v0.0.6...v0.0.7](https://github.com/nepalez/abbyy-cloud/compare/v0.0.6...v0.0.7)

# [v0.0.6 2016-09-09](https://github.com/nepalez/abbyy-cloud/tree/v0.0.6)

### Added

* Operation `files.upload` (nepalez)
* Operation `files.download` (nepalez)
* Operation `orders.create(options)` (nepalez)
* Operation `orders.find(id)` (nepalez)

[Compare v0.0.5...v0.0.6](https://github.com/nepalez/abbyy-cloud/compare/v0.0.5...v0.0.6)

# [v0.0.5 2016-08-23](https://github.com/nepalez/abbyy-cloud/tree/v0.0.5)

### Fixed

* Loading order (nepalez)

[Compare v0.0.4...v0.0.5](https://github.com/nepalez/abbyy-cloud/compare/v0.0.4...v0.0.5)

# [v0.0.4 2016-08-23](https://github.com/nepalez/abbyy-cloud/tree/v0.0.4)

### Added

* Operation `mt.engine(name)` (nepalez)
* Operation `mt.default_engine` (nepalez)
* Operation `mt.translate` instead of `orders.translate` (nepalez)
* Operation `mt.translate_segments` (nepalez)
* Operation `prices.details` (nepalez)
* Validation of locales following IANA & RFC-5646 (nepalez)

### Deleted

* Namespace `orders` (nepalez)
* Remove :version settings (nepalez)
  Every operation has its own version. No global API version is supported.
  When necessary, a version will be send to the operation.

### Internal

* Added support for query part of a request (nepalez)

[Compare v0.0.3...v0.0.4](https://github.com/nepalez/abbyy-cloud/compare/v0.0.3...v0.0.4)

# [v0.0.3 2016-08-18](https://github.com/nepalez/abbyy-cloud/tree/v0.0.3)

### Bugs Fixed

* Fix version in root path to ABBYY Cloud API (nepalez)
* Fix validation of language names (nepalez)
* Allow ResponseError to take response with non-json body (nepalez)

### Added

* Operation `.mt.engines` (nepalez)

### Changed

* Remove validation of engine names (nepalez)

### Internal

* Add coverage to all models (nepalez)
* Add method `Types.register_type` for custom types (nepalez)

[Compare v0.0.2...v0.0.3](https://github.com/nepalez/abbyy-cloud/compare/v0.0.2...v0.0.3)

# [v0.0.2 2016-08-18](https://github.com/nepalez/abbyy-cloud/tree/v0.0.2)

### Changed

* Move `#translation` from root to `#orders` namespace (nepalez)

  Instead of `client.translation(*)` use `client.orders.translation(*)`

* Make `#translation` return model `ABBYY::Cloud::Models::Translation` instead of hash (nepalez)

### Internal

* Extract settings from root object and isolate them in the shareable container `ABBYY::Cloud::Settings` (nepalez)
* Add namespaces for operations (nepalez)
* Add models for objects returned by operations (nepalez)

[Compare v0.0.1...v0.0.2](https://github.com/nepalez/abbyy-cloud/compare/v0.0.1...v0.0.2)

# [v0.0.1 2016-08-16](https://github.com/nepalez/abbyy-cloud/tree/v0.0.1)

First public release
