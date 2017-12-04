#
# Cookbook:: cookbook-beagle-cluster
# Recipe:: static_mount_app
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#

delete_resource(:map_entry, '/app')

delete_lines 'remove auto /app' do
  path node['autofs']['/-']['map']
  pattern '^/app*'
  notifies :run, 'execute[mount_app]', :immediately
end

service 'autofs' do
  action :restart
end

execute 'mount_app' do
  command '/bin/mount /app || echo discarding error $?'
  action :nothing
end
