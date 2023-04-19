terraform {
  required_providers {

    vsphere = {
      source  = "hashicorp/vsphere"
      #version = "2.1.1"
    }
  }
}



## Configure the vSphere Provider

provider "vsphere" {
  vsphere_server = var.vsphere_server
  user           = var.vsphere_user
  password       = var.vsphere_password
  #password = data.vault_generic_secret.vcpass.data["tfuser"]
  allow_unverified_ssl = true
}

