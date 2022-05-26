name 'geolite2'
maintainer 'Aleksandr Piatkin'
maintainer_email 'oss@aptkn.ch'
license 'MIT'
description 'Download GeoLite2 databases'
long_description ::IO.read(::File.join(::File.dirname(__FILE__), 'README.md'))
version '2.2.0'

scm_url = 'https://github.com/aspyatkin/geolite2-cookbook'
source_url scm_url if respond_to?(:source_url)
issues_url "#{scm_url}/issues" if respond_to?(:issues_url)

supports 'ubuntu'
