#
# Cookbook:: cookbook-beagle-cluster
# Recipe:: slurm_controller
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'slurm-wlm::slurmctld'

template '/var/lib/slurm-llnl/slurm-power-control.py' do
  source 'slurm-power-control.py.erb'
  owner 'root'
  mode '0755'
end

link '/var/lib/slurm-llnl/resume' do
  to '/var/lib/slurm-llnl/slurm-power-control.py'
end

link '/var/lib/slurm-llnl/suspend' do
  to '/var/lib/slurm-llnl/slurm-power-control.py'
end

template '/etc/default/slurmctld' do
  source 'slurmctld.default.erb'
  owner 'root'
  mode '0644'
  variables(
    'config_path' => node['beagle']['configs']['etcdir']
  )
  notifies :reload, "service[#{node['slurm-wlm']['services']['slurmctld']}]", :delayed
end
