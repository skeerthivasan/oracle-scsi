

vsphere_server = "mera.puretec.purestorage.com"
vsphere_user = "administrator@vsphere.local"
vsphere_password = ""

#common
osguest_id = "rhel8_64Guest"
internal_domain = "puretec.purestorage.com"
vmSubnet = "vlan-2210"
dns_servers = ["10.21.237.250"]
vm_cluster = "DBClus"
dc = "Databases"

vm_gateway = "10.21.118.1"


#vm 
vm_count = "1"
vm_name = "demo"
network = "10.21.118.0"
netmask = "24"
vm_ip = ["10.21.118.22"]
vmware_os_template = "linux-rhel-8-v23.07"
vm_cpus = 32
vm_memory = 65536
os_disk_size = "100"
data_disk_size = "50"
datastore_os = "Metro_Cluster1_Prod01"
datastore_data = "Metro_Cluster1_Prod01"
contentlib_name = "SolutionsLab-ContentLib"












