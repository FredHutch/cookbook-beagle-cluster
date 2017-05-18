#
# Cookbook:: beagle-cluster
# Recipe:: node
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#
# configure a beagle compute node- slurmd &c
#

node.default['slurm-wlm']['config']['slurm']['ClusterName'] = \
  node['beagle']['cluster_name']
node.default['slurm-wlm']['config']['slurm']['ControlMachine'] = \
  node['beagle']['controller']

template '/etc/slurm-llnl/slurm-nodes.conf' do
  source 'slurm-nodes.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/slurm-llnl/slurm-partitions.conf' do
  source 'slurm-partitions.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

include_recipe 'slurm-wlm'

