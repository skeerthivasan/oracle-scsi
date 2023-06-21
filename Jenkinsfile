pipeline {
    agent any
    options {
        ansiColor('xterm')
    }
    parameters {
        choice(choices: ['MySql','MSSQL', 'Postgres', 'Oracle'], description: 'Select the Solution to build', name: 'solution')
        string(name: 'count', defaultValue: "0", description: 'Number of VMs')
        choice(choices: ['fsvc', 'vc3'], description: 'Select the VC to use', name: 'vcenter')
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
	
	
	def path = workspace + "/" + "modules" + "/" + sol.trim()
	println "path ------${path}-----"
	dir(path) {

	    if (params.Build) {
            println "Updating backend file"
            sh script: "sed -i -e 's/sol_name/"+sol.trim()+"/g' backend.tf"
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
            sh script: "python3 ../../build-inventory.py " + sol.trim()
            sh script: "cat hosts.ini"
        }
        if (params.Install) {
			println "Installing and conifguring the solution"
            sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/common.yml --private-key "  + '${SSH_KEY}' + " --user ansible"
            sh script: "ansible-playbook -i 10.21.152.65, ../../ansible/playbooks/prometheus-config.yml --private-key "  + '${SSH_KEY}' + " --user root"  + " -e solution=" +  sol.trim() + " --connection-password-file pss.txt"

            //sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/" + sol.trim().toLowerCase() + "-install.yml --private-key "  + '${SSH_KEY}' + " --user ansible"
			// execute ansible playbook
        }
        if (params.Test) {
			println "Executing Performance step"
 
            sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/" + sol.trim().toLowerCase() + "-test.yml --private-key "  + '${SSH_KEY}' + " --user ansible"
			// execute ansible playbook
        }

        if (params.Destroy) {
            if (params.Build) {
                println "Build already executed in this pipeline" 
            } else {
                println "Executing Infrstructure destroy step" 
                sh script: "sed -i -e 's/sol_name/"+sol.trim()+"/g' backend.tf"
                sh script: "${tf_cmd} init -reconfigure"
			    sh script: "${tf_cmd} destroy -auto-approve -var-file=$path"  + "/main.tfvars" + " -var vsphere_password=" + '${VC_PASS}'	+ " -var ansible_key=" + '${SSH_KEY}'	 +	 " -var infoblox_pass=" + '${INFOBLOX_PASS}'	 +	" -var vm_count=" + '${vm_count}'	
            }
			
        }

	}
	
	
	
	
  }
      
