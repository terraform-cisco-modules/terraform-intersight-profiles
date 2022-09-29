#__________________________________________________________________
#
# Model Data and policy from domains and pools
#__________________________________________________________________

variable "model" {
  description = "Model data."
  type        = any
}

variable "policies" {
  description = "Policies Moids."
  type        = any
}

variable "pools" {
  description = "Pool Moids."
  type        = any
}
