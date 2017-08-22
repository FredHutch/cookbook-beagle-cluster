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

# Set paths &c
node.override['slurm-wlm']['files'] = {
  'configdir' => node['beagle']['configs']['etcdir'],
  'rundir' => node['beagle']['configs']['rundir'],
  'logdir' => node['beagle']['configs']['logdir'],
  'spooldir' => node['beagle']['configs']['spooldir']
}

slurm_paths = {
  'Include' => [
    "#{node['beagle']['configs']['etcdir']}/slurm-nodes.conf",
    "#{node['beagle']['configs']['etcdir']}/slurm-partitions.conf"
  ],
  'JobCheckpointDir' => "#{node['beagle']['configs']['spooldir']}/checkpoint",
  'SlurmdSpoolDir' => "#{node['beagle']['configs']['spooldir']}/slurmd",
  'StateSaveLocation' => "#{node['beagle']['configs']['spooldir']}/state",
  'SlurmctldPidFile' => "#{node['beagle']['configs']['rundir']}/slurmctld.pid",
  'SlurmctldLogFile' => "#{node['beagle']['configs']['logdir']}/slurmctld.log",
  'SlurmdPidFile' => "#{node['beagle']['configs']['rundir']}/slurmd.%n.pid",
  'SlurmdLogFile' => "#{node['beagle']['configs']['logdir']}/slurmd.%n.log",
  'SlurmSchedLogFile' => "#{node['beagle']['configs']['logdir']}/sched.log",
  'Prolog' => "#{node['beagle']['configs']['etcdir']}/slurmd.prolog",
  'Epilog' => "#{node['beagle']['configs']['etcdir']}/slurmd.epilog",
  'TaskProlog' => "#{node['beagle']['configs']['etcdir']}/task.prolog.sh"
}

node.override['slurm-wlm']['config']['slurm'] = \
  node['beagle']['configs']['slurm_conf'].merge(slurm_paths)

include_recipe 'slurm-wlm'

remote_file "#{node['beagle']['configs']['etcdir']}/slurm-partitions.conf" do
  source node['beagle']['configs']['slurm_partitions_uri']
  mode '0644'
  owner 'root'
  group 'root'
end

remote_file "#{node['beagle']['configs']['etcdir']}/slurm-nodes.conf" do
  source node['beagle']['configs']['slurm_node_uri']
  mode '0644'
  owner 'root'
  group 'root'
end

template 'slurmd.prolog' do
  path "#{node['beagle']['configs']['etcdir']}/slurmd.prolog"
  source 'slurmd.prolog.erb'
  mode '0755'
  owner 'root'
  group 'root'
end

template 'slurmd.epilog' do
  path "#{node['beagle']['configs']['etcdir']}/slurmd.epilog"
  source 'slurmd.epilog.erb'
  mode '0755'
  owner 'root'
  group 'root'
end

template 'task.prolog.sh' do
  path "#{node['beagle']['configs']['etcdir']}/task.prolog.sh"
  source 'task.prolog.sh.erb'
  mode '0755'
  owner 'root'
  group 'root'
end
