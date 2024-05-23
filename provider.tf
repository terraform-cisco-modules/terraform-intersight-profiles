#_______________________________________________________________________
#
# Terraform Required Parameters - Intersight Provider
# https://registry.terraform.io/providers/CiscoDevNet/intersight/latest
#_______________________________________________________________________

terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.41"
      #version = ">=1.0.48"
    }
    time = {
      source  = "time"
      version = ">=0.9.1"
    }
  }
  required_version = ">=1.3.0"
}
