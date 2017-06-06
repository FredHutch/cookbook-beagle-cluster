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
    'config' => node['slurm-wlm']['config']['slurm']
  )
  notifies :reload, "service[#{node['slurm-wlm']['services']['slurmd']}]", :delayed
end
