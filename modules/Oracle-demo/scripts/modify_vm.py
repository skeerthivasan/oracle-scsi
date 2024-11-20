import requests
import warnings
import json
from urllib3.exceptions import InsecureRequestWarning
from requests.auth import HTTPBasicAuth
import argparse
warnings.simplefilter("ignore", InsecureRequestWarning)


# Set up argument parsing
parser = argparse.ArgumentParser(description='Get vCenter API token.')
parser.add_argument('vcenter_url', help='The vCenter URL (e.g., https://<vcenter-server>/rest/com/vmware/cis/session)')
parser.add_argument('username', help='The username for vCenter authentication')
parser.add_argument('password', help='The password for vCenter authentication')
parser.add_argument('vmname', help='vmname for search')

# Parse the arguments
args = parser.parse_args()

# Send POST request to get the token
response = requests.post(f"https://{args.vcenter_url}/rest/com/vmware/cis/session", auth=HTTPBasicAuth(args.username, args.password), verify=False)

# Check for successful response
if response.status_code == 200:
    token = response.json()['value']
else:
    print(f"Failed to obtain token. Status code: {response.status_code}, Message: {response.text}")

headers = {
    "vmware-api-session-id": token
}

esx_hosts = {}
response = requests.get(f"https://{args.vcenter_url}/rest/vcenter/vm?filter.names.1={args.vmname}", headers=headers, verify=False)
# Check for successful response
if response.status_code == 200:
    hosts = response.json()
    vm = hosts['value'][0]['vm']
    data = {
    "spec": {
        "sharing": "PHYSICAL"
      }
    } 
    print('Stopping VM....')
    requests.post(f"https://{args.vcenter_url}/rest/vcenter/vm/{vm}/power/stop", headers=headers, verify=False)
    res = requests.patch(f"https://{args.vcenter_url}/rest/vcenter/vm/{vm}/hardware/adapter/scsi/1003", headers=headers, json=data, verify=False)
    if res.status_code == 200:
        print('Changed scsi bus sharing')
    requests.post(f"https://{args.vcenter_url}/rest/vcenter/vm/{vm}/power/start", headers=headers, verify=False)
    print('Starting VM....')
 
    #print(json.dumps(hosts))
else:
    print(f"Failed to fetch hosts. Status code: {response.status_code}, Message: {response.text}")
