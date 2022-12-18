#__________________________________________________________________
#
# Model Data and policy from domains and pools
#__________________________________________________________________

variable "model" {
  description = "Model data."
  type        = any
}

variable "moids" {
  default     = false
  description = "Flag to Determine if Policies Should be associated using data object or resource."
  type        = bool
}

variable "organization" {
  default     = "default"
  description = "Name of the default intersight Organization."
  type        = string
}

variable "policies" {
  description = "Policies Moids."
  type        = any
}

variable "pools" {
  description = "Pool Moids."
  type        = any
}

variable "tags" {
  default     = []
  description = "List of Key/Value Pairs to Assign as Attributes to the Policy."
  type        = list(map(string))
}