# beagle-cluster

Configures a node for the beagle cluster.  Primarily installs Slurm components
based on role in the Chef server.  There are three roles:

 - controller
 - database server
 - compute node

Some special checks are specific to the test environment: it will install local
accounts used for testing and disable some other networked features (i.e run
standalone).

# Configuration

## Attributes

 - `node['beagle']['vault_name']`: Name of the vault containing configurations

## Vault Data Storage

These items are stored in a Vault (see `node['beagle']['vault_name']` above):

 - `{users}`: hash containing local users to create and encrypted password
 - `{"users": {"alice": "password"}}`: an entry creating a local user


## Templates

 - `slurm.conf.erb`: a template for use by the slurm cookbook

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
