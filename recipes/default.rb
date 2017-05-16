#
# Cookbook:: beagle-cluster
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'chef-vault'
node.override['beagle']['configs'] = chef_vault_item(
  node['beagle']['vault_name'], 'configs'
)
