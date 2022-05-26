require 'uri'
require 'net/http'

resource_name :geolite2_city_database

property :license_key, String, required: true
property :url, String, default: 'https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=%{license_key}&suffix=tar.gz'
property :url_checksum, String, default: 'https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=%{license_key}&suffix=tar.gz.sha256'

property :path, String, default: '/etc/chef-geolite2'

default_action :install

action :install do
  directory new_resource.path do
    mode 0o700
    recursive true
    action :create
  end

  city_database_dir = ::File.join(new_resource.path, "city_#{new_resource.name}")

  directory city_database_dir do
    mode 0o700
    recursive true
    action :create
  end

  city_database_tarball = 'GeoLite2-City.tar.gz'
  city_database_tarball_path = ::File.join(
    ::Chef::Config['file_cache_path'],
    city_database_tarball
  )

  download_url = new_resource.url % { license_key: new_resource.license_key }
  download_url_checksum = new_resource.url_checksum % { license_key: new_resource.license_key}

  remote_file city_database_tarball_path do
    source download_url
    checksum lazy { ::ChefCookbook::GeoLite2.get_checksum(node, 'city', download_url_checksum) }
    mode 0644
  end

  city_database_file = 'GeoLite2-City.mmdb'
  city_database_path = ::File.join(city_database_dir, city_database_file)

  execute "Unpack GeoLite2-City database #{new_resource.name}" do
    command "tar -zxvf #{city_database_tarball_path} --no-same-owner --wildcards --no-anchored --strip-components 1 '#{city_database_file}'"
    cwd city_database_dir
    creates city_database_path
    action :run
  end

  ::ChefCookbook::GeoLite2.add(
    node,
    'city',
    new_resource.name,
    city_database_path
  )
end
