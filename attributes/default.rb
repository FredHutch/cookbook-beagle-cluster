
node.default['beagle']['vault_name'] = 'beagle_vault'
node.default['beagle']['cluster_name'] = 'beagle'
node.default['beagle']['controller'] = 'beagle-ctld'
node.override['slurm-wlm']['templates']['cookbook'] = 'beagle-cluster'
node.override['slurm-wlm']['templates']['slurm_conf'] = 'slurm-core.conf.erb'

node.override['slurm-wlm']['services']['slurmd'] = 'slurmd'
node.override['slurm-wlm']['services']['slurmctld'] = 'slurmctld'

node.override['slurm-wlm']['packages']['slurmctld'] = 'slurmctld'
node.override['slurm-wlm']['packages']['slurmd'] = 'slurmd'
node.override['slurm-wlm']['packages']['slurmdbd'] = 'slurmdbd'

node.override['app']['server'] = 'scdata'
node.override['app']['path'] = '/scdata_01_S20/app'
