

vsphere_server = "10.21.93.100"
vsphere_user = "unnir"
vsphere_password = ""

#common
osguest_id = "rhel8_64Guest"
internal_domain = "puretec.purestorage.com"
vmSubnet = "VLAN2152"
dns_servers = ["10.21.237.250"]
vm_cluster = "se-shared-test-pod"
dc = ""

vm_gateway = "10.21.152.1"


#vm 
vm_count = "5"
vm_name = "mysql-vm"
network = "10.21.152.0"
netmask = "24"
vm_ip = ["10.21.152.165"]
vmware_os_template = "rhel8_packer11082022"
vm_cpus = 16
vm_memory = 16384
os_disk_size = "100"
data_disk_size = "10"
datastore_os = "Template"
datastore_data = "Template"












