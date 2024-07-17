variable "name" {
  type        = string
  default     = "test"
  description = "Name of the resource. Provided by the client when the resource is created. "
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] ."
}

variable "managedby" {
  type        = string
  default     = ""
  description = "ManagedBy, eg yadavprakash."
}

variable "repository" {
  type        = string
  default     = "https://github.com/yadavprakash/terraform-gcp-bastion-host.git"
  description = "Terraform current module repo"
}

variable "image_family" {
  type        = string
  description = "Source image family for the Bastion."
  default     = "ubuntu-2204-lts"
}

variable "image_project" {
  type        = string
  description = "Project where the source image for the Bastion comes from"
  default     = "ubuntu-os-cloud"
}

variable "create_instance_from_template" {
  type        = bool
  description = "Whether to create and instance from the template or not. If false, no instance is created, but the instance template is created and usable by a MIG"
  default     = true
}

variable "labels" {
  type        = map(any)
  description = "Key-value map of labels to assign to the bastion host"
  default     = {}
}

variable "members" {
  type        = list(string)
  description = "List of IAM resources to allow access to the bastion host"
  default     = []
}

variable "network" {
  type        = string
  default     = ""
  description = "Self link for the network on which the Bastion should live"
}

variable "service_account_roles" {
  type        = list(string)
  description = "List of IAM roles to assign to the service account."
  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/compute.osLogin",
  ]
}

variable "service_account_roles_supplemental" {
  type        = list(string)
  description = "An additional list of roles to assign to the bastion if desired"
  default     = []
}

variable "service_account_name" {
  type        = string
  description = "Account ID for the service account"
  default     = "bastion"
}

variable "service_account_email" {
  type        = string
  description = "If set, the service account and its permissions will not be created. The service account being passed in should have at least the roles listed in the `service_account_roles` variable so that logging and OS Login work as expected."
  default     = ""
}

variable "subnet" {
  type        = string
  description = "Self link for the subnet on which the Bastion should live. Can be private when using IAP"
}

variable "zone" {
  type        = string
  description = "The primary zone where the bastion host will live"
  default     = "us-west1-a"
}

variable "region" {
  type        = string
  description = "The region where the bastion instance template will live"
  default     = "us-west1"
}

variable "random_role_id" {
  type        = bool
  description = "Enables role random id generation."
  default     = true
}

variable "additional_ports" {
  description = "A list of additional ports/ranges to open access to on the instances from IAP."
  type        = list(string)
  default     = []
}

#variable "access_config" {
#  description = "Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet."
#  type = list(object({
#    nat_ip       = string
#    network_tier = string
#  }))
#  default = [
#    {
#      network_tier = ""
#      nat_ip       = ""
#    }
#  ]
#}

variable "create_firewall_rule" {
  type        = bool
  description = "If we need to create the firewall rule or not."
  default     = true
}

variable "ssh-keys" {
  type    = string
  default = ""
}
