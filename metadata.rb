name 'geolite2'
maintainer 'Alexander Pyatkin'
maintainer_email 'aspyatkin@gmail.com'
license 'MIT'
description 'Download GeoLite2 databases'
long_description ::IO.read(::File.join(::File.dirname(__FILE__), 'README.md'))
version '1.0.0'

scm_url = 'https://github.com/aspyatkin/geolite2-cookbook'
source_url scm_url if respond_to?(:source_url)
issues_url "#{scm_url}/issues" if respond_to?(:issues_url)

supports 'ubuntu'