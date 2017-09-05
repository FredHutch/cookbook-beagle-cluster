#
# Cookbook:: cookbook-beagle-cluster
# Recipe:: chef_atboot
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#
# Run chef-client at node startup

template '/etc/init.d/chef-atboot' do
  source 'chef-atboot'
  owner 'root'
  group 'root'
  mode '0755'
end

link '/etc/rc2.d/S19chef-atboot' do
  to '/etc/init.d/chef-atboot'
end

link '/etc/rc3.d/S19chef-atboot' do
  to '/etc/init.d/chef-atboot'
end
