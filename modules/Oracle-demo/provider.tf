
terraform {
  required_providers {

    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.10.0"
    }
    infoblox = {
    source = "infobloxopen/infoblox"
    version = "2.8.0"
    }
  }
}



## Configure the vSphere Provider

provider "vsphere" {
  vsphere_server = var.vsphere_server
  user           = var.vsphere_user
  password       = var.vsphere_password

  allow_unverified_ssl = true
}

provider "infoblox" {
username = "svc_fb_infoblox_auto"
password = "PASSREMOVED"
server = "prod-ipam.puretec.purestorage.com"
}
