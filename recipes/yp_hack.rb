#
# Cookbook:: cookbook-beagle-cluster
# Recipe:: yp_hack
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#
# Reload ypbind at the end of the converge

service 'ypbind' do
  action :restart
end
