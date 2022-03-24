# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).


## [2.1.0] - 2023-03-23

Add function to download the Maxmind Geolite2 ASN database.

### Added
- Added `geolite2_asn_database` function. 

## [2.0.0] - 2020-02-16

Make use of MaxMind account license key so as to download databases.

### Added
- Added `license_key` attribute to `geolite2_city_database` and `geolite2_country_database` resources.

## [1.0.0] - 2019-04-28

First appearance in public.

### Added
- Upload the cookbook to [Chef Supermarket](https://supermarket.chef.io/cookbooks/geolite2).
