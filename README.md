# geolite2 cookbook
[![Chef cookbook](https://img.shields.io/cookbook/v/geolite2.svg?style=flat-square)]()
[![license](https://img.shields.io/github/license/aspyatkin/geolite2-cookbook.svg?style=flat-square)]()  
Chef cookbook to download GeoLite2 Free databases from [MaxMind](https://dev.maxmind.com/geoip/geoip2/geolite2/).

## Prerequisites
MaxMind account license key is required in order to download GeoLite2 Free databases. Read more [here](https://blog.maxmind.com/2019/12/18/significant-changes-to-accessing-and-using-geolite2-databases/).

## Resources

### geolite2_country_database

Download the latest GeoLite2 Country database

``` ruby
geolite2_country_database 'default' do
  license_key 'ABCD...'  # MaxMind account license key
end
```

### geolite2_city_database

Download the latest GeoLite2 City database

``` ruby
geolite2_city_database 'default' do
  license_key 'ABCD...'  # MaxMind account license key
end
```

### geolite2_asn_database

Download the latest GeoLite2 ASN database

``` ruby
geolite2_asn_database 'default' do
  license_key 'ABCD...'  # MaxMind account license key
end
```

## Helpers

``` ruby
# Get a full path to a GeoLite2 Country database
::ChefCookbook::GeoLite2.country_database(node, 'default')  # /etc/chef-geolite2/country_default/GeoLite2-Country.mmdb

# Get a full path to a GeoLite2 City database
::ChefCookbook::GeoLite2.city_database(node, 'default')  # /etc/chef-geolite2/city_default/GeoLite2-City.mmdb

# Get a full path to a GeoLite2 ASN database
::ChefCookbook::GeoLite2.asn_database(node, 'default')  # /etc/chef-geolite2/asn_default/GeoLite2-ASN.mmdb
```

## License
MIT @ [Aleksandr Piatkin](https://github.com/aspyatkin)
