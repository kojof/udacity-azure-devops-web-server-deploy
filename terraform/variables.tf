variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "eastus"
}

# variable "resource_group_name" {
#   description = "The name of the resource group in which the resources are created"
#   default     = ""
# }


variable "admin_username" {
  description = "Admin User"
  default = "azureadmin"
}

variable "admin_password" {
  description = "Admin Password"
  default = "P@ssw0rd1234!"
}

variable "vm_instances_count" {
  description = "virtual machine count"
  type        = number
  default     = 3
}

variable "tagging_policy" {
    description = "A policy tag that ensures all resources in subscription need to be tagged."
    type        = map(string)

    default = {   
        project-name = "udacity-terraform-project"
 }
}