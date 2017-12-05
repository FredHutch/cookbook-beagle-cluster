#
# Cookbook:: cookbook-beagle-cluster
# Recipe:: static_mount_app
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#

delete_lines 'remove auto /app' do
  path node['autofs']['/-']['map']
  pattern '^/app*'
end

service 'autofs' do
  action :restart
end
