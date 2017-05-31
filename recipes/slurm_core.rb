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

directory '/etc/slurm-llnl' do
  owner 'root'
  group 'root'
  mode '0755'
end

template '/etc/slurm-llnl/slurm-nodes.conf' do
  source 'slurm-nodes.conf.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables(
    'node_data' => node['beagle']['node_data']
  )
end

include_recipe 'slurm-wlm'
