variable "os_user_name" {}

variable "os_project_name" {}

variable "os_user_password" {}

variable "os_domain_name" {}

variable "os_auth_url" {}

variable "os_region" {}

variable srv_instance_prefix_name {
  type    = "string"
  default = "srv"
}

variable "master_instance_count" {
  default = 1
}

variable master_instance_prefix_name {
  type    = "string"
  default = "master"
}

variable "slave_instance_count" {
  default = 2
}

variable slave_instance_prefix_name {
  type    = "string"
  default = "slave"
}

variable "server_vcpus" {
  default = 1
}

variable "server_ram_mb" {
  default = 1024
}

variable "server_root_disk_gb" {
  default = 10
}

variable "server_image_name" {}

variable "server_zone" {
  default = "ru-3a"
}

variable "server_ssh_key" {}

variable "server_ssh_key_user" {}
