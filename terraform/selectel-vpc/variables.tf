# Selectel credentials
variable sel_account {
  description = "You selectel account number"
}

variable sel_token {
  description = "Selectel X-Token"
  type        = "string"
}

# OpenStack identity vars
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

# OpenStack instances vars
variable srv_instance_prefix_name {
  type    = "string"
  default = "srv"
}

variable master_instance_count {
  default = 1
}

variable master_instance_prefix_name {
  type    = "string"
  default = "master"
}

variable slave_instance_count {
  default = 2
}

variable slave_instance_prefix_name {
  type    = "string"
  default = "slave"
}

variable instance_zone {
  type = "string"
}

variable instance_vcpus {
  description = "CPU"
  default     = 1
}

variable instance_ram_mb {
  description = "DRAM"
  default     = 1024
}

variable instance_root_disk_gb {
  description = "Storage size"
  default     = 10
}

variable instance_image_name {
  description = "OpenStack image name"
  type        = "string"
  default     = "Ubuntu 18.04 LTS 64-bit"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
  type        = "string"
}
