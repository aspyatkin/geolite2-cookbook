require 'uri'
require 'net/http'
require 'digest/md5'

resource_name :geolite2_country_database

property :url, String, default: 'http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz'
property :url_checksum, String, default: 'https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz.md5'

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

  remote_file country_database_tarball_path do
    source new_resource.url
    use_conditional_get true
    use_etag true
    use_last_modified true
    verify do |path|
      uri = URI(new_resource.url_checksum)
      res = ::Net::HTTP.get_response(uri)
      if res.is_a?(::Net::HTTPSuccess)
        next res.body == ::Digest::MD5.file(path).hexdigest
      else
        next false
      end
    end
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
