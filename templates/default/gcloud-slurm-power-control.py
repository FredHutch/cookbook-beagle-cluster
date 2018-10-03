#!/usr/bin/env python

# Resume or suspend nodes indicated in the argument list.
#
# Slurm will call this program as `resume` or `suspend` with a Slurm hostlist
# as its argument.  This will expand the Slurm hostlist
# (nodename[1-2,4],othername1, etc) and build an instance list from this
# expanded list by searching on the `Name` tag

import sys
import os
import googleapiclient
from apiclient.discovery import build

import logging
# Uses NSC hostlist (https://www.nsc.liu.se/~kent/python-hostlist/)
import hostlist

GCLOUD_PROJECT = 'dev9-gcp-practice-sandbox'
LOG_FILE_PATH  = '/tmp/test-slurm-power-control.log'

logging.basicConfig(
        filename=LOG_FILE_PATH,
        format='%(asctime)s %(levelname)-8s %(message)s',
        level=logging.INFO
        )

gcloud_service = build('compute', 'v1')

# Link to this script with "resume" or "suspend", vis:
#    resume  -> slurm-power-control.py
#    suspend -> slurm-power-control.py
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
assert action in ('suspend', 'resume'), "action should be 'suspend' or 'resume'"

logging.info("Starting: action {} on nodes {}".format(action, nodelist_raw))

nodelist = hostlist.expand_hostlist(nodelist_raw)


machines = []
for z in ['us-west1-a', 'us-west1-b', 'us-west1-c']:
    machines_req  = gcloud_service.instances().list(project=GCLOUD_PROJECT,
                                                    zone=z)
    machines_resp = machines_req.execute()
    machines += machines_resp.get('items', [])

logging.debug("GCloud query complete")

filtered_machines = []
for m in machines:
    if m['name'] in nodelist:
        filtered_machines.append(m)

logging.debug("describing instances in nodelist: {}".format(nodelist))
logging.debug(
    "complete, {} records found".format(len(machines))
)

# check for non-empty result
if len(filtered_machines) == 0:
    logging.debug("Filter returned empty list {}".format(nodelist))
    raise NameError("name(s) not found")

filtered_machine_names = [fm['name'] for fm in filtered_machines]
if action == 'resume':
    logging.info("Resuming/starting instances: {}".format(filtered_machine_names))
elif action == 'suspend':
    logging.info("Suspending/stopping instances: {}".format(filtered_machine_names))

instances = gcloud_service.instances()
for fm in filtered_machines:
    zone = fm['zone'].split('/')[-1]
    name = fm['name']
    if action == 'resume':
        response = instances.start(project=GCLOUD_PROJECT,
                                   zone=zone,
                                   instance=name
                                   ).execute()
    elif action == 'suspend':
        response = instances.stop( project=GCLOUD_PROJECT,
                                   zone=zone,
                                   instance=name
                                   ).execute()
    has_expected_response = response['status'] in ('PENDING', 'DONE')
    if not has_expected_response:
        logging.info("unexpected response status: {}".format(response['status']))
    assert has_expected_response


