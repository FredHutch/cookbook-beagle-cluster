#
# Cookbook:: cookbook-beagle-cluster
# Recipe:: slurm_controller
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'slurm-wlm::slurmctld'
include_recipe 'poise-python'

# Add boto3 and hostlist for power (EC2) control
python_runtime '3'
python_package 'boto3'
python_package 'python-hostlist'

template '/var/lib/slurm-llnl/slurm-power-control.py' do
  source 'slurm-power-control.py'
  owner 'root'
  mode '0755'
end

link '/var/lib/slurm-llnl/resume' do
  to '/var/lib/slurm-llnl/slurm-power-control.py'
end

link '/var/lib/slurm-llnl/suspend' do
  to '/var/lib/slurm-llnl/slurm-power-control.py'
end

# Create mountpoint for state directory (if requested)
mount node['beagle']['configs']['slurm_conf']['StateSaveLocation'] do
  device node['beagle']['configs']['state_save']['device']
  fstype node['beagle']['configs']['state_save']['fstype']
  options node['beagle']['configs']['state_save']['options']
  action %i[mount enable]
  not_if { node['beagle']['configs']['state_save'].empty? }
end

template '/etc/default/slurmctld' do
  source 'slurmctld.default.erb'
  owner 'root'
  mode '0644'
  variables(
    'config_path' => node['beagle']['configs']['etcdir']
  )
  notifies \
    :reload, \
    "service[#{node['slurm-wlm']['services']['slurmctld']}]", \
    :delayed
end
