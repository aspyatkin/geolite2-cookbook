require 'uri'
require 'net/http'

class Chef
  class Exceptions
    class GeoLite2DatabaseNotFoundError < RuntimeError
    end

    class GetLite2ChecksumUnavailableError < RuntimeError
    end
  end
end

module ChefCookbook
  module GeoLite2
    def self.init(node)
      unless node.run_state.key?('geolite2')
        node.run_state['geolite2'] = {
          'country' => {},
          'city' => {},
          'asn' => {}
        }
      end
    end

    def self.add(node, item_type, item_name, path)
      init(node)
      node.run_state['geolite2'][item_type][item_name] = path
    end

    def self._database(node, item_type, item_name)
      init(node)
      unless node.run_state['geolite2'][item_type].key?(item_name)
        raise ::Chef::Exceptions::GeoLite2DatabaseNotFoundError,
              "A GeoLite2 #{item_type} database not found by the name '#{name}'!"
      end
      node.run_state['geolite2'][item_type][item_name]
    end

    def self.country_database(node, item_name)
      _database(node, 'country', item_name)
    end

    def self.city_database(node, item_name)
      _database(node, 'city', item_name)
    end

    def self.asn_database(node, item_name)
      _database(node, 'asn', item_name)
    end

    def self.get_checksum(node, item_type, url_checksum)
      checksum = nil
      begin
        uri = URI(url_checksum)
        res = ::Net::HTTP.get_response(uri)
        if res.is_a?(::Net::HTTPSuccess)
          checksum = res.body.strip.split(' ')[0]
        end
      rescue => e
        Chef::Log.error(e.message)
      end

      if checksum.nil?
        raise ::Chef::Exceptions::GetLite2ChecksumUnavailableError,
              "A checksum for GeoLite2 #{item_type} database could not be retrieved!"
      end

      checksum
    end
  end
end
