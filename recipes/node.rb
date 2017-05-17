#
# Cookbook:: beagle-cluster
# Recipe:: node
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#
# configure a beagle compute node- slurmd &c
#

node.default['slurm-wlm']['config']['ClusterName'] = 
  node['beagle']['cluster_name']
node.default['slurm-wlm']['config']['ControlMachine'] = 
  node['beagle']['controller']

include_recipe 'slurm-wlm'
