

vsphere_server = "10.21.199.130"
vsphere_user = "administrator@vsphere.local"
vsphere_password = ""

#common
osguest_id = "rhel8_64Guest"
internal_domain = "puretec.purestorage.com"
vmSubnet = "Infra-VLAN2199"
dns_servers = ["10.21.93.16"]
vm_cluster = "Infra cluster"
dc = "DP Test Bed"

vm_gateway = "10.21.199.1"


#vm 
vm_count = "1"
vm_name = "cvlt-test-vm"
network = "10.21.199.0"
netmask = "24"
vm_ip = ["10.21.199.173"]
vmware_os_template = "rhel8_packer11082022"
vm_cpus = 4
vm_memory = 8192

os_disk_size = "100"
data_disk_size = "10"
datastore_os = "DP-test-bed-infra-DS"
datastore_data = "DP-test-bed-infra-DS"












