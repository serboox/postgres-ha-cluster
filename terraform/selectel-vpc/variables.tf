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
variable master_server_name {
  type    = "string"
  default = "Master"
}

variable slave_server_name {
  type    = "string"
  default = "Slave"
}

variable srv_server_name {
  type    = "string"
  default = "Srv"
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

variable public_key_path {
  description = "Path to the public key used for ssh access"
  type        = "string"
}
