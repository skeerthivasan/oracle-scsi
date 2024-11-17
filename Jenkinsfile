pipeline {
    agent any
    options {
        ansiColor('xterm')
    }
    parameters {
        choice(choices: ['MySql','MSSQL', 'Postgres', 'Oracle','spark-dev', 'Commvault', 'cyberark3'], description: 'Select the Solution to build', name: 'solution')
        //choice(choices: ['cowriter','MySql','MSSQL', 'MSSQLDC', 'Postgres', 'Oracle','winjump','logrhythm','syslog','qradar','superna','superna-ubuntu','util','k8s', 'Oracle-rac', 'splunk', 'superna-windows','superna-windows2','superna-windows3','superna-windows-19','akriti-ubuntu', 'linux-ubuntu', 'spark', 'cyberark', 'cyberark1', 'cyberark2', 'cyberark3', 'spark-dev', 'veeam-backup-and-replication','cyberark-pvwa', 'veeam'], description: 'Select the Solution to build', name: 'solution')
        string(name: 'count', defaultValue: "0", description: 'Number of VMs')
        choice(choices: ['fsvc', 'shared-vc'], description: 'Select the VC to use', name: 'vcenter')
        booleanParam(name: 'Build', defaultValue: false, description: 'Build Intrastructure')
        booleanParam(name: 'Install', defaultValue: false, description: 'Install and configure solution')
	    booleanParam(name: 'Test', defaultValue: false, description: 'Run the performance test')
	    booleanParam(name: 'Destroy', defaultValue: false, description: 'Destroy Intrastructure')
		
    }

    stages {
        stage('Build solution') {
            environment {
                SSH_KEY = credentials('ansible')
                VC_PASS = credentials("${params.vcenter}")
                INFOBLOX_PASS = credentials('infoblox')
                AWS_ACCESS_KEY_ID = 'PSFBSAZRAECJNHNFJEKCPOHOOPMGMKMJLIJLKBCMLB'
                AWS_SECRET_ACCESS_KEY = credentials('s3token')
                ANSIBLE_HOST_KEY_CHECKING = "False"
                ANSIBLE_ROLES_PATH = "../../ansible/roles"
                vm_count = "${params.count}".toInteger()
            }
            steps {
                
                script {
    		        sh "echo Hello from Build stage"
                    //sh 'echo ssh key from script section - ${SSH_KEY}'
    		        sol_name = params.solution
    		        build_solution(sol_name)
    	         }
                  }
        }
    }
}


  def build_solution(sol) {
    def tf_cmd = "/usr/bin/terraform"
	def workspace = pwd()
	println "workspace ------${workspace}-----"
	
	def solname = sol.trim()
	def path = workspace + "/" + "modules" + "/" + solname
	println "path ------${path}-----"
	dir(path) {

	    if (params.Build) {
              if (solname == 'veeam') {
                println  "Setting Veeam Setup VM"
                def vpath = workspace + "/" + "modules" + "/" + "veeam-setup".trim()
		println "vpath ------${vpath}-----"

		echo "Original Directory: ${pwd()}"
		dir("/var/lib/jenkins/workspace/Solution-automation/modules/veeam-setup") {
 		  sh "pwd"
        	  echo "Inside anotherDir: ${pwd()}"
	 	  println "Updating backend file"
            	  sh script: "sed -i -e 's/sol_name/"+solname+"/g' backend.tf"
		  println "Executing Infrstructure build step" 
            	  sh script: "/bin/rm -rf .terraform"
	          print  "sh script: ${tf_cmd} init -upgrade"
	          sh script: "${tf_cmd} init -upgrade"
            	  count = sh(script: "grep vm_count main.tfvars | awk  '{print \$3}' |xargs", returnStdout: true)
            	  //count = sh(script: "cat hosts.ini|wc -l", returnStdout: true)
           	  println count
            	  println vm_count
            	  total_count = vm_count.toInteger() + count.toInteger()
            	  println total_count
	          sh script: "${tf_cmd} destroy -auto-approve -var-file=$vpath"  + "/main.tfvars" + " -var vsphere_password=" + '${VC_PASS}'	+ " -var ansible_key=" + '${SSH_KEY}'	 +	 " -var infoblox_pass=" + '${INFOBLOX_PASS}'	 +	" -var vm_count=" + '${vm_count}'	
		  sh script: "$tf_cmd apply -auto-approve -var-file=$vpath"  + "/main.tfvars" + " -var vsphere_password=" + '${VC_PASS}'	 + " -var ansible_key=" + '${SSH_KEY}'	+	 " -var infoblox_pass=" + '${INFOBLOX_PASS}'  +	" -var vm_count=" + total_count
            	  sh script: "python3 ../../build-inventory.py " + "veeam-setup"
            	  sh script: "cat hosts.ini"
               }

	       dir("/var/lib/jenkins/workspace/Solution-automation/modules/veeam-windows-backupproxy-server") {
            	  println  "Creating: Veeam - Windows BackUp Proxy Server"
                  def vwpath = workspace + "/" + "modules" + "/" + "veeam-windows-backupproxy-server".trim()
		  println "vpath ------${vpath}-----"
	          sh "pwd"
        	  echo "Inside anotherDir: ${pwd()}"
	 	  println "Updating backend file"
            	  sh script: "sed -i -e 's/sol_name/"+solname+"/g' backend.tf"
		  println "Executing Infrstructure build step" 
            	  sh script: "/bin/rm -rf .terraform"
	          print  "sh script: ${tf_cmd} init -upgrade"
	          sh script: "${tf_cmd} init -upgrade"
            	  count = sh(script: "grep vm_count main.tfvars | awk  '{print \$3}' |xargs", returnStdout: true)
            	  //count = sh(script: "cat hosts.ini|wc -l", returnStdout: true)
           	  println count
            	  println vm_count
            	  total_count = vm_count.toInteger() + count.toInteger()
            	  println total_count
	          sh script: "${tf_cmd} destroy -auto-approve -var-file=$vwpath"  + "/main.tfvars" + " -var vsphere_password=" + '${VC_PASS}'	+ " -var ansible_key=" + '${SSH_KEY}'	 +	 " -var infoblox_pass=" + '${INFOBLOX_PASS}'	 +	" -var vm_count=" + '${vm_count}'	
		  sh script: "$tf_cmd apply -auto-approve -var-file=$vwpath"  + "/main.tfvars" + " -var vsphere_password=" + '${VC_PASS}'	 + " -var ansible_key=" + '${SSH_KEY}'	+	 " -var infoblox_pass=" + '${INFOBLOX_PASS}'  +	" -var vm_count=" + total_count
            	  sh script: "python3 ../../build-inventory.py " + "veeam-windows-backupproxy-server"
            	  sh script: "cat hosts.ini"
	       }

      	       dir("/var/lib/jenkins/workspace/Solution-automation/modules/veeam-linux-backupproxy-server") {
            	  println  "Creating: Veeam - Linux BackUp Proxy Server"
                  def vlpath = workspace + "/" + "modules" + "/" + "veeam-linux-backupproxy-server".trim()
		  println "vpath ------${vpath}-----"
	          sh "pwd"
        	  echo "Inside anotherDir: ${pwd()}"
	 	  println "Updating backend file"
            	  sh script: "sed -i -e 's/sol_name/"+solname+"/g' backend.tf"
		  println "Executing Infrstructure build step" 
            	  sh script: "/bin/rm -rf .terraform"
	          print  "sh script: ${tf_cmd} init -upgrade"
	          sh script: "${tf_cmd} init -upgrade"
            	  count = sh(script: "grep vm_count main.tfvars | awk  '{print \$3}' |xargs", returnStdout: true)
            	  //count = sh(script: "cat hosts.ini|wc -l", returnStdout: true)
           	  println count
            	  println vm_count
            	  total_count = vm_count.toInteger() + count.toInteger()
            	  println total_count
	          sh script: "${tf_cmd} destroy -auto-approve -var-file=$vlpath"  + "/main.tfvars" + " -var vsphere_password=" + '${VC_PASS}'	+ " -var ansible_key=" + '${SSH_KEY}'	 +	 " -var infoblox_pass=" + '${INFOBLOX_PASS}'	 +	" -var vm_count=" + '${vm_count}'	
		  sh script: "$tf_cmd apply -auto-approve -var-file=$vlpath"  + "/main.tfvars" + " -var vsphere_password=" + '${VC_PASS}'	 + " -var ansible_key=" + '${SSH_KEY}'	+	 " -var infoblox_pass=" + '${INFOBLOX_PASS}'  +	" -var vm_count=" + total_count
            	  sh script: "python3 ../../build-inventory.py " + "veeam-linux-backupproxy-server"
            	  sh script: "cat hosts.ini"
	      }


	    } else {
            	println "Updating backend file"
            	sh script: "sed -i -e 's/sol_name/"+solname+"/g' backend.tf"
			println "Executing Infrstructure build step" 
            	sh script: "/bin/rm -rf .terraform"
	        print  "sh script: ${tf_cmd} init -upgrade"
	        sh script: "${tf_cmd} init -upgrade"
            	count = sh(script: "grep vm_count main.tfvars | awk  '{print \$3}' |xargs", returnStdout: true)
            	//count = sh(script: "cat hosts.ini|wc -l", returnStdout: true)
           	 println count
            	println vm_count
            	def total_count = vm_count.toInteger() + count.toInteger()
            	println total_count
		sh script: "$tf_cmd apply -auto-approve -var-file=$path"  + "/main.tfvars" + " -var vsphere_password=" + '${VC_PASS}'	 + " -var ansible_key=" + '${SSH_KEY}'	+	 " -var infoblox_pass=" + '${INFOBLOX_PASS}'  +	" -var vm_count=" + total_count
            	sh script: "python3 ../../build-inventory.py " + solname
            	sh script: "cat hosts.ini"
	   }
        }
        if (params.Install) {
			println "Installing and conifguring the solution"
            
            println solname
            println "------------------"
            if (solname == 'MSSQLDC') {
                sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/" +  "common-win.yml"
                sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/" + solname.toLowerCase() + "-install.yml"
            } 
            if  (solname == 'Oracle') {
                sh script: "cd /root/Oracle-build/ansible;export ANSIBLE_COLLECTIONS_PATHS=/root/.ansible/collections/ansible_collections/;export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3.6;ansible-playbook -i inventory-asm-demo -e hostgroup=dbfs  playbooks/single-instance-asm.yml --private-key "  + '${SSH_KEY}' + " --user ansible -vvvv"
            }
            if  (solname == 'veeam') {
		sh script: pwd 
                sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/" +  "common.yml --private-key "  + '${SSH_KEY}' + " --user ansible"
            }
            else {
                sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/" +  "common.yml --private-key "  + '${SSH_KEY}' + " --user ansible"
                sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/" + solname.toLowerCase() + "-install.yml --private-key "  + '${SSH_KEY}' + " --user ansible"
            }
                
           
			
        }
        if (params.Test) {
			println "Executing Performance step"
            sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/" + solname.toLowerCase() + "-test.yml --private-key "  + '${SSH_KEY}' + " --user ansible"
        }

        if (params.Destroy) {
            if (params.Build) {
                println "Build already executed in this pipeline" 
            } else {
                println "Executing Infrstructure destroy step" 
                sh script: "sed -i -e 's/sol_name/"+solname+"/g' backend.tf"
                sh script: "${tf_cmd} init -reconfigure"
			    sh script: "${tf_cmd} destroy -auto-approve -var-file=$path"  + "/main.tfvars" + " -var vsphere_password=" + '${VC_PASS}'	+ " -var ansible_key=" + '${SSH_KEY}'	 +	 " -var infoblox_pass=" + '${INFOBLOX_PASS}'	 +	" -var vm_count=" + '${vm_count}'	
            }
			
        }

	}
	
	
	
	
  }
      
