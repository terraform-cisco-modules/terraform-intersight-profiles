#_______________________________________________________________________
#
# Terraform Required Parameters - Intersight Provider
# https://registry.terraform.io/providers/CiscoDevNet/intersight/latest
#_______________________________________________________________________

terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.54"
    }
    time = {
      source  = "time"
      version = ">=0.9.1"
    }
  }
  required_version = ">=1.3.0"
}
