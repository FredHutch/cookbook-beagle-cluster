
node.default['beagle']['vault_name'] = 'beagle_vault'
node.default['beagle']['cluster_name'] = 'beagle'
node.default['beagle']['controller'] = 'beagle-ctld'
node.override['slurm-wlm']['templates']['cookbook'] = 'beagle-cluster'
node.override['slurm-wlm']['templates']['slurm_conf'] = 'slurm-core.conf.erb'