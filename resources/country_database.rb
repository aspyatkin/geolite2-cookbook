require 'uri'
require 'net/http'
require 'digest/md5'

resource_name :geolite2_country_database

property :license_key, String, required: true
property :url, String, default: 'https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country&license_key=%{license_key}&suffix=tar.gz'
property :url_checksum, String, default: 'https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country&license_key=%{license_key}&suffix=tar.gz.sha256'

property :path, String, default: '/etc/chef-geolite2'

default_action :install

action :install do
  directory new_resource.path do
    mode 0o700
    recursive true
    action :create
  end

  country_database_dir = ::File.join(new_resource.path, "country_#{new_resource.name}")

  directory country_database_dir do
    mode 0o700
    recursive true
    action :create
  end

  country_database_tarball = 'GeoLite2-Country.tar.gz'
  country_database_tarball_path = ::File.join(
    ::Chef::Config['file_cache_path'],
    country_database_tarball
  )

  download_url = new_resource.url % { license_key: new_resource.license_key }
  download_url_checksum = new_resource.url_checksum % { license_key: new_resource.license_key}

  remote_file country_database_tarball_path do
    source download_url
    checksum lazy { ::ChefCookbook::GeoLite2.get_checksum(node, 'country', download_url_checksum) }
    mode 0644
  end

  country_database_file = 'GeoLite2-Country.mmdb'
  country_database_path = ::File.join(country_database_dir, country_database_file)

  execute "Unpack GeoLite2-Country database #{new_resource.name}" do
    command "tar -zxvf #{country_database_tarball_path} --no-same-owner --wildcards --no-anchored --strip-components 1 '#{country_database_file}'"
    cwd country_database_dir
    creates country_database_path
    action :run
  end

  ::ChefCookbook::GeoLite2.add(
    node,
    'country',
    new_resource.name,
    country_database_path
  )
end
