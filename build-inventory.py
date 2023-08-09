import json
import subprocess
import sys
import os
print(os.getcwd())
sol = sys.argv[1]
process = subprocess.Popen(["terraform", "output", "-json"],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
out, err = process.communicate()
ouput = out.decode('utf-8')

data = json.loads(ouput)
ips = data['vm_ip']['value']
names = data['vm_name']['value']
#filename = 'modules/' + sol +  '/hosts.ini'
var_filename = 'hosts.yml'
filename = 'hosts.ini'
print(filename)

# check if  the solution is windows
# prepare the hosts.ini with more details to login 
if sol == 'MSSQL' or 'MSSQLDC':
    print(sol)
    with open(filename,'w') as fh:
        fh.write("[win]\n")
        for name in names:
            fh.write(name.rstrip().split('.')[0]+ '.fslab.local' + '\n')
        fh.write("[win:vars]\n")
        # fh.write("ansible_user=administrator\n")
        # fh.write("ansible_password=VMware1!\n")
        fh.write("ansible_user=vidm@FSLAB.LOCAL\n")
        fh.write("ansible_password=Osmium76$\n")
        fh.write("ansible_connection=winrm\n")
        fh.write("ansible_winrm_server_cert_validation=ignore\n")
        fh.write("ansible_port=5985\n")
        fh.write("ansible_winrm_scheme=http\n")
        fh.write("ansible_winrm_kerberos_delegation=true\n")
        fh.write("ansible_winrm_transport=kerberos\n")
        
else:
    with open(filename,'w') as fh:
        for ip in ips:
            fh.write(ip.rstrip() + '\n')

    with open(var_filename,'w') as fh:
        fh.write('hg:' + '\n')
        for ip in ips:
            fh.write(' - ' + ip.rstrip() + '\n')


