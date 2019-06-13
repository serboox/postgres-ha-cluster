# Selectel credentials
variable OS_AUTH_URL {
  default = "https://api.selvpc.ru/identity/v3"
  type    = "string"
}

variable OS_X_TOKEN {
  description = "Selectel X-Token"
  type        = "string"
}

# OpenStack identity vars
variable OS_PROJECT_NAME {
  type    = "string"
}

variable OS_USER_DOMAIN_NAME {
  description = "You selectel account number"
}

variable OS_USERNAME {
  type    = "string"
}

variable OS_PASSWORD {
  type    = "string"
}

variable OS_REGION {
  type    = "string"
}

variable OS_AVAILABILITY_ZONE {
  type    = "string"
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
