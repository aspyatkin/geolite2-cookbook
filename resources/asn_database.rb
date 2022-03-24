require 'uri'
require 'net/http'
require 'digest/md5'

resource_name :geolite2_asn_database

property :license_key, String, required: true
property :url, String, default: 'https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-ASN&license_key=%{license_key}&suffix=tar.gz'
property :url_checksum, String, default: 'https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-ASN&license_key=%{license_key}&suffix=tar.gz.md5'

property :path, String, default: '/etc/chef-geolite2'

default_action :install

action :install do
  directory new_resource.path do
    mode 0o700
    recursive true
    action :create
  end

  asn_database_dir = ::File.join(new_resource.path, "asn_#{new_resource.name}")

  directory asn_database_dir do
    mode 0o700
    recursive true
    action :create
  end

  asn_database_tarball = 'GeoLite2-ASN.tar.gz'
  asn_database_tarball_path = ::File.join(
    ::Chef::Config['file_cache_path'],
    asn_database_tarball
  )

  download_url = new_resource.url % { license_key: new_resource.license_key }
  download_url_checksum = new_resource.url_checksum % { license_key: new_resource.license_key}

  remote_file asn_database_tarball_path do
    source download_url
    use_conditional_get true
    use_etag true
    use_last_modified true
    verify do |path|
      uri = URI(download_url_checksum)
      res = ::Net::HTTP.get_response(uri)
      if res.is_a?(::Net::HTTPSuccess)
        next res.body == ::Digest::MD5.file(path).hexdigest
      else
        next false
      end
    end
    mode 0644
  end

  asn_database_file = 'GeoLite2-ASN.mmdb'
  asn_database_path = ::File.join(asn_database_dir, asn_database_file)

  execute "Unpack GeoLite2-ASN database #{new_resource.name}" do
    command "tar -zxvf #{asn_database_tarball_path} --no-same-owner --wildcards --no-anchored --strip-components 1 '#{asn_database_file}'"
    cwd asn_database_dir
    creates asn_database_path
    action :run
  end

  ::ChefCookbook::GeoLite2.add(
    node,
    'asn',
    new_resource.name,
    asn_database_path
  )
end
