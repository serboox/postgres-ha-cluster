# Selectel credentials
variable sel_account {
  description = "You selectel account number"
}

variable sel_token {
  description = "Selectel X-Token"
  type        = "string"
}

# OpenStack auth
variable os_project_name {
  type = "string"
}

variable os_user_name {
  type = "string"
}

variable os_user_password {
  type = "string"
}

variable "os_auth_url" {
  type    = "string"
  default = "https://api.selvpc.ru/identity/v3"
}

variable os_region {
  type = "string"
}

variable os_zone {
  type = "string"
}

variable instance_count {
  default = 1
}

variable server_name {
  type = "string"
  default = "Node"
}

variable server_zone {
  type = "string"
}

variable server_vcpus {
  description = "CPU"
  default     = 1
}

variable server_ram_mb {
  description = "DRAM"
  default     = 1024
}

variable server_root_disk_gb {
  description = "Storage size"
  default     = 10
}

variable server_image_name {
  description = "OpenStack image name"
  type        = "string"
  default     = "Ubuntu 18.04 LTS 64-bit"
}

# Openstack project vars
variable custom_url {
  description = "Dirrect URL to you project"
  type        = "string"
}

variable theme_color {
  description = "Colors in project page"
  type        = "string"
  default     = "2753E9"
}

variable quota_compute_cores {
  description = "How many cores need for you project"
  default     = 4
}

variable quota_compute_ram {
  description = "How many DRAM need for you project"
  default     = 8
}

variable quota_volume_gigabytes_fast {
  description = "How many storage need for you project"
  default     = 120
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
  type        = "string"
}
