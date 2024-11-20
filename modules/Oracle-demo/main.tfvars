
vsphere_server = "flashstack-vcenter.puretec.purestorage.com"
vsphere_user = "administrator@vsphere.local"
vsphere_password = "PASSREMOVED"
infoblox_pass = ""

#common
osguest_id = "oracleLinux64Guest"
internal_domain = "puretec.purestorage.com"
vmSubnet = "2210"
dns_servers = ["10.21.93.16"]
vm_cluster = "MetroCluster1"
dc = "SolutionsLab"
vm_gateway = "10.21.210.1"
#vm 
vm_count = "1"
vm_name = "keerthi-demo"
network = "10.21.210.0"
netmask = "24"
vm_ip = ["10.21.210.22"]
vmware_os_template = "linux-oel-8-v24.10"
vm_cpus = 16
vm_memory = 65536
os_disk_size = "100"
data_disk_size = "200"
datastore_os = "Metro_Cluster1_Prod01"
datastore_data = "vvOLs-Metro"
contentlib_name = "SolutionsLab-ContentLib"
