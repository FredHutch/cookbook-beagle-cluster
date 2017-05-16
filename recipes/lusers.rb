#
# Cookbook:: beagle-cluster
# Recipe:: lusers
#
# Copyright:: 2017, The Authors, All Rights Reserved.

#
# Create local users from Vault
#
include_recipe 'beagle-cluster::default'

users = node['beagle']['configs']['users']
users.each do |u, pw|
  user u do
    username u
    password pw
    shell '/bin/bash'
  end
end
