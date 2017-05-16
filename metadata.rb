name 'beagle-cluster'
maintainer 'Scientific Computing, FredHutch'
maintainer_email 'scicomp@fhcrc.org'
license 'Creative Commons Attribution-ShareAlike 4.0'
description 'Installs/Configures beagle-cluster nodes'
long_description 'Installs/Configures beagle-cluster nodes'

issues_url 'https://github.com/FredHutch/beagle-cluster/issues'
source_url 'https://github.com/FredHutch/beagle-cluster'

version '0.1.0'
supports 'ubuntu', '>= 14.04'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'chef-vault', '~> 0.2.0'
