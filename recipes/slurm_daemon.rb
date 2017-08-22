# Cookbook:: cookbook-beagle-cluster
# Recipe:: slurm_daemon
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'slurm-wlm::slurmd'

template '/etc/default/slurmd' do
  source 'slurmd.default.erb'
  owner 'root'
  mode '0644'
  variables(
    'config_path' => node['beagle']['configs']['etcdir']
  )
  notifies \
    :reload, \
    "service[#{node['slurm-wlm']['services']['slurmd']}]", \
    :delayed
end
