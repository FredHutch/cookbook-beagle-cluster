
node.default['beagle']['vault_name'] = 'beagle_vault'
node.default['beagle']['cluster_name'] = 'beagle'
node.default['beagle']['controller'] = 'beagle-ctld'

default['slurm-wlm']['repository']['uri'] = \
  'http://octopus.fhcrc.org/aptly/public'

node.override['slurm-wlm']['templates']['cookbook'] = 'beagle-cluster'
node.override['slurm-wlm']['templates']['slurm_conf'] = 'slurm-core.conf.erb'

node.override['slurm-wlm']['services']['slurmd'] = 'slurmd'
node.override['slurm-wlm']['services']['slurmctld'] = 'slurmctld'

node.override['slurm-wlm']['packages']['client'] = 'slurm-client'
node.override['slurm-wlm']['packages']['slurmctld'] = 'slurmctld'
node.override['slurm-wlm']['packages']['slurmd'] = 'slurmd'
node.override['slurm-wlm']['packages']['slurmdbd'] = 'slurmdbd'

node.default['beagle']['configs'] = {
  'slurm_node_uri' => 'https://s3-us-west-2/bucket/slurm-nodes.conf',
  'slurm_partitions_uri' => 'https://s3-us-west-2/bucket/slurm-partitions.conf',
  'spooldir' => '/var/spool/slurm-llnl',
  'etcdir' => '/etc/slurm-llnl',
  'rundir' => '/run/slurm-llnl',
  'logdir' => '/var/log/slurm-llnl',
  'state_save' => {
    'device' => '/var/tmp',
    'fstype' => 'auto',
    'options' => 'bind'
  },
  'slurm_conf' => {
    'ClusterName' => 'beagle-tk',
    'ControlMachine' => 'beagle-tk',
    'AuthType' => 'auth/munge',
    'CacheGroups' => '0',
    'SlurmSchedLogLevel' => '0',
    'StateSaveLocation' => '/var/spool/slurm-llnl/state'
  }
}
