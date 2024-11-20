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
response = requests.get(f"https://{args.vcenter_url}/rest/vcenter/host", headers=headers, verify=False)
# Check for successful response
if response.status_code == 200:
    hosts = response.json()
    names = [item['name'] for item in hosts['value'] if item.get('connection_state') == 'CONNECTED']
    #esx_hosts[host["host"]] = names
    #esx_hosts = {}
    for host in hosts.get("value", []):
        if host.get("connection_state") == "CONNECTED":
            esx_hosts[host["host"]] = host["name"]
    print(json.dumps(esx_hosts))
else:
    print(f"Failed to fetch hosts. Status code: {response.status_code}, Message: {response.text}")
