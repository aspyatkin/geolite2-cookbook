# geolite2 cookbook
[![Chef cookbook](https://img.shields.io/cookbook/v/geolite2.svg?style=flat-square)]()
[![license](https://img.shields.io/github/license/aspyatkin/geolite2-cookbook.svg?style=flat-square)]()  
Chef cookbook to download GeoLite2 Free databases from [MaxMind](https://dev.maxmind.com/geoip/geoip2/geolite2/).

## Resources

### geolite2_country_database

Download the latest GeoLite2 Country database

``` ruby
geolite2_country_database 'default'
```

### geolite2_city_database

Download the latest GeoLite2 City database

``` ruby
geolite2_city_database 'default'
```

## Helpers

``` ruby
# Get a full path to a GeoLite2 Country database
::ChefCookbook::DHParam.file(node, 'default')  # /etc/chef-geolite2/country_default/GeoLite2-Country.mmdb

# Get a full path to a GeoLite2 City database
::ChefCookbook::DHParam.file(node, 'default')  # /etc/chef-geolite2/city_default/GeoLite2-City.mmdb
```

## License
MIT @ [Alexander Pyatkin](https://github.com/aspyatkin)
