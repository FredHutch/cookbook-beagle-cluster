#
# Cookbook:: cookbook-beagle-cluster
# Recipe:: static_mount_app
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#

delete_resource(:map_entry, '/app')

delete_lines 'remove auto /app' do
  path node['beagle']['autofs']['/-']['map']
  pattern '^/app*'
end