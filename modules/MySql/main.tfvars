

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

vm_gateway = "10.21.210.1"


#vm 
vm_count = "8"
vm_name = "mysql"
network = "10.21.210.0"
netmask = "24"
vm_ip = ["10.21.210.22"]
vmware_os_template = "linux-rhel-8-v23.07"
vm_cpus = 32
vm_memory = 65536
os_disk_size = "100"
data_disk_size = "1500"
datastore_os = "X90r3-vVol"
datastore_data = "X90r3-vVol"
contentlib_name = "SolutionsLab-ContentLib"












