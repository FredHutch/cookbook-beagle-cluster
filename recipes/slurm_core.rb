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

remote_file '/etc/slurm-llnl/slurm-nodes.conf' do
  source node['beagle']['configs']['slurm_node_uri']
  owner 'root'
  group 'root'
  mode '0644'
end

include_recipe 'slurm-wlm'
