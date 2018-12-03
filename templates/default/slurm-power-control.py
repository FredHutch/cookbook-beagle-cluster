#!/usr/bin/env python3

# Resume or suspend nodes indicated in the argument list.
#
# Slurm will call this program as `resume` or `suspend` with a Slurm hostlist
# as its argument.  This will expand the Slurm hostlist
# (nodename[1-2,4],othername1, etc) and build an instance list from this
# expanded list by searching on the `Name` tag

import sys
import os
import boto3

import logging
logging.basicConfig(
        filename='/var/log/slurm-llnl/slurm-power-control.log',
        format='%(asctime)s %(levelname)-8s %(message)s',
        level=logging.INFO
        )

# Uses NSC hostlist (https://www.nsc.liu.se/~kent/python-hostlist/)
import hostlist

# Link to this script with "resume" or "suspend", vis:
#    resume -> slurm-power-control.py
#    slurm-power-control.py
#
# The name indicates the action and is thus found in argv[0].  We'll use this
# downstream when it's time to actually perform an action (the remaining logic
# of assembling the list of instances is identical in either case)

# ...unless there are two arguments on the command-line, in which case we
# use argv[1] as the action, and argv[2] as the node list

if len(sys.argv) == 2:
    action = os.path.basename(sys.argv[0])
    nodelist_raw = sys.argv[1]
else:
    action = os.path.basename(sys.argv[1])
    nodelist_raw = sys.argv[2]

logging.info("Starting: action {} on nodes {}".format(action, nodelist_raw))

nodelist = hostlist.expand_hostlist(nodelist_raw)

ec2 = boto3.client('ec2', region_name='us-west-2')
logging.debug("EC2 client connection complete")

# build filter list:

# Only instances with names matching those in the nodelist
instance_filter = [{'Name': 'tag:Name', 'Values': nodelist }]

# Only instances running/stopped
instance_filter.append(
  {'Name': 'instance-state-name', 'Values': ['stopped', 'running']}
)

logging.debug("describing instances with filter {}".format(instance_filter))
response = ec2.describe_instances( Filters = instance_filter )
logging.debug(
    "complete, {} records found".format(len(response['Reservations']))
)

# check for non-empty result
if len(response['Reservations']) == 0:
    logging.debug("Filter returned empty list {}".format(nodelist))
    raise NameError("name(s) not found")
# Build list of instances from this response.  The instance id is found in 
# r['Reservations'][N]['Instances'][0]['InstanceId']

instance_ids = []
for r in response['Reservations']:
    instance_ids.append(r['Instances'][0]['InstanceId'])

logging.debug("acting on instances {}".format(instance_ids))
if action == 'resume':
    logging.info("Resuming/starting instances: {}".format(instance_ids))
    response = ec2.start_instances(InstanceIds=instance_ids)
elif action == 'suspend':
    logging.info("Suspending/stopping instances: {}".format(instance_ids))
    response = ec2.stop_instances(InstanceIds=instance_ids)
