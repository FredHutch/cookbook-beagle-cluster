#
# Cookbook:: cookbook-beagle-cluster
# Recipe:: munge
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#
# Install munge key from databag
#

bag  = node['local_configs']['munge']['data_bag_name']
item = node['local_configs']['munge']['data_bag_item']
key  = data_bag_item(bag, item)[node['local_configs']['munge']['key']]

munge_key_contents = Base64.decode64(key)

include_recipe 'slurm-wlm::munge'
delete_resource!(:cookbook_file, '/etc/munge/munge.key')

file 'munge key' do
  path '/etc/munge/munge.key'
  content munge_key_contents
  owner 'munge'
  group 'root'
  mode '0400'
  notifies :start, 'service[munge]', :immediate
end
