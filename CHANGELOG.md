# Changelog

## [3.2.0](https://github.com/CloudNationHQ/terraform-azure-redis/compare/v3.1.0...v3.2.0) (2026-01-16)


### Features

* add tenant_settings & active_directory_authentication_enabled to redis cache configuration ([#45](https://github.com/CloudNationHQ/terraform-azure-redis/issues/45)) ([aa6c742](https://github.com/CloudNationHQ/terraform-azure-redis/commit/aa6c7423cdf6d425447d440fb2852117459bef32))
* **deps:** bump github.com/cloudnationhq/az-cn-go-validor in /tests ([#43](https://github.com/CloudNationHQ/terraform-azure-redis/issues/43)) ([06a805f](https://github.com/CloudNationHQ/terraform-azure-redis/commit/06a805f1dcf15333b8b26441f96d87934e77d8e3))
* **deps:** bump golang.org/x/crypto from 0.36.0 to 0.45.0 in /tests ([#41](https://github.com/CloudNationHQ/terraform-azure-redis/issues/41)) ([e2d3525](https://github.com/CloudNationHQ/terraform-azure-redis/commit/e2d3525bc478b337321d3b5c49d09881e36187f1))

## [3.1.0](https://github.com/CloudNationHQ/terraform-azure-redis/compare/v3.0.0...v3.1.0) (2025-11-12)


### Features

* **deps:** bump github.com/ulikunitz/xz from 0.5.10 to 0.5.14 in /tests ([#34](https://github.com/CloudNationHQ/terraform-azure-redis/issues/34)) ([b1da8af](https://github.com/CloudNationHQ/terraform-azure-redis/commit/b1da8af5b39835236d6da604612cbae7e8e602d8))
* remove redundant null values ([#39](https://github.com/CloudNationHQ/terraform-azure-redis/issues/39)) ([6d8f073](https://github.com/CloudNationHQ/terraform-azure-redis/commit/6d8f0737a812e9d72b53fb0712cc1c3b110f44b7))

## [3.0.0](https://github.com/CloudNationHQ/terraform-azure-redis/compare/v2.3.0...v3.0.0) (2025-06-06)


### ⚠ BREAKING CHANGES

* The data structure changed, causing a recreate on existing resources.

### Features

* small refactor ([#30](https://github.com/CloudNationHQ/terraform-azure-redis/issues/30)) ([6619305](https://github.com/CloudNationHQ/terraform-azure-redis/commit/661930584150fc74d09b0f7edddd0f43d2777beb))

### Upgrade from v2.3.0 to v3.0.0:

- Update module reference to: `version = "~> 3.0"`
- The user assigned identity is removed from the module.
  - For identity we created a separate module.
- The property and variable resource_group is renamed to resource_group_name

## [2.3.0](https://github.com/CloudNationHQ/terraform-azure-redis/compare/v2.2.0...v2.3.0) (2025-01-20)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#19](https://github.com/CloudNationHQ/terraform-azure-redis/issues/19)) ([0b822cc](https://github.com/CloudNationHQ/terraform-azure-redis/commit/0b822cc0b70bb0d48729324145d4f8703bba051b))
* **deps:** bump golang.org/x/crypto from 0.29.0 to 0.31.0 in /tests ([#22](https://github.com/CloudNationHQ/terraform-azure-redis/issues/22)) ([17d38a3](https://github.com/CloudNationHQ/terraform-azure-redis/commit/17d38a3c77b2f1de54ca6cd0c49458df59b9d3af))
* **deps:** bump golang.org/x/net from 0.31.0 to 0.33.0 in /tests ([#23](https://github.com/CloudNationHQ/terraform-azure-redis/issues/23)) ([2e57e23](https://github.com/CloudNationHQ/terraform-azure-redis/commit/2e57e230b4f02f5b1bd314c1f206d51f26ac0779))
* remove temporary files when deployment tests fails ([#20](https://github.com/CloudNationHQ/terraform-azure-redis/issues/20)) ([8d846dc](https://github.com/CloudNationHQ/terraform-azure-redis/commit/8d846dcfa6d4173c1dacc59b6d4a4c7f8ed29f65))

## [2.2.0](https://github.com/CloudNationHQ/terraform-azure-redis/compare/v2.1.0...v2.2.0) (2024-11-12)


### Features

* enhance testing with sequential, parallel modes and flags for exceptions and skip-destroy ([#16](https://github.com/CloudNationHQ/terraform-azure-redis/issues/16)) ([4beefd2](https://github.com/CloudNationHQ/terraform-azure-redis/commit/4beefd26030c26a5aabf456246a54e6c13e2e418))

## [2.1.0](https://github.com/CloudNationHQ/terraform-azure-redis/compare/v2.0.1...v2.1.0) (2024-10-11)


### Features

* auto generated docs and refine makefile ([#14](https://github.com/CloudNationHQ/terraform-azure-redis/issues/14)) ([0e0276f](https://github.com/CloudNationHQ/terraform-azure-redis/commit/0e0276fb0945374760b64b3acc440bbb1188f822))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#13](https://github.com/CloudNationHQ/terraform-azure-redis/issues/13)) ([52474f6](https://github.com/CloudNationHQ/terraform-azure-redis/commit/52474f68d6d7572b2124afe1e57d9179c2217499))

## [2.0.1](https://github.com/CloudNationHQ/terraform-azure-redis/compare/v2.0.0...v2.0.1) (2024-09-25)


### Bug Fixes

* fix global tags and updated documentation ([#11](https://github.com/CloudNationHQ/terraform-azure-redis/issues/11)) ([f5dd69d](https://github.com/CloudNationHQ/terraform-azure-redis/commit/f5dd69d39d01fa9ce66b0c38bc0bd84602cec0a1))

## [2.0.0](https://github.com/CloudNationHQ/terraform-azure-redis/compare/v1.0.2...v2.0.0) (2024-09-24)


### ⚠ BREAKING CHANGES

* Version 4 of the azurerm provider includes breaking changes.

### Features

* upgrade azurerm provider to v4 ([#9](https://github.com/CloudNationHQ/terraform-azure-redis/issues/9)) ([67da887](https://github.com/CloudNationHQ/terraform-azure-redis/commit/67da887dae373596e8a599be3336fe939e89c686))

### Upgrade from v1.0.2 to v2.0.0:

- Update module reference to: `version = "~> 2.0"`

## [1.0.2](https://github.com/CloudNationHQ/terraform-azure-redis/compare/v1.0.1...v1.0.2) (2024-09-12)


### Bug Fixes

* remove reference to synapse ([#7](https://github.com/CloudNationHQ/terraform-azure-redis/issues/7)) ([0261dab](https://github.com/CloudNationHQ/terraform-azure-redis/commit/0261dabbb28abef3dcbc58ef756316a604a9b53e))

## [1.0.1](https://github.com/CloudNationHQ/terraform-azure-redis/compare/v1.0.0...v1.0.1) (2024-09-11)


### Bug Fixes

* fix description cache variable ([#5](https://github.com/CloudNationHQ/terraform-azure-redis/issues/5)) ([19c0a6b](https://github.com/CloudNationHQ/terraform-azure-redis/commit/19c0a6b4af308084cd2c9ab112256d402176de9a))

## 1.0.0 (2024-09-02)


### Features

* add initial resources ([#2](https://github.com/CloudNationHQ/terraform-azure-redis/issues/2)) ([6fdacfc](https://github.com/CloudNationHQ/terraform-azure-redis/commit/6fdacfc507320e5bbc8d245ca55edd30128a1b10))
