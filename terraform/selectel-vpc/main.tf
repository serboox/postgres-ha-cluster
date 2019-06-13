terraform {
  # Версия terraform
  required_version = "~> 0.11.12"
}

provider "selectel" {
  token = "${var.sel_token}"
}

# Create the main project with user.
# This module should be applied first:
# terraform apply -target=module.project_with_user
module "project_with_user" {
  source = "../modules/selectel-vpc/project_with_user"

  project_name  = "${var.os_project_name}"
  user_name     = "${var.os_user_name}"
  user_password = "${var.os_user_password}"
}

module "server-master-1" {
  source = "../modules/selectel-vpc/server_remote_root_disk"

  # OpenStack auth.
  os_project_name  = "${var.os_project_name}"
  os_user_name     = "${var.os_user_name}"
  os_user_password = "${var.os_user_password}"
  os_domain_name   = "${var.sel_account}"
  os_auth_url      = "${var.os_auth_url}"
  os_region        = "${var.os_region}"

  # OpenStack Instance parameters.
  server_name         = "${format("%s-%d", var.master_server_name, 1)}"
  server_zone         = "${var.server_zone}"
  server_vcpus        = "${var.server_vcpus}"
  server_ram_mb       = "${var.server_ram_mb}"
  server_root_disk_gb = "${var.server_root_disk_gb}"
  server_image_name   = "${var.server_image_name}"
  server_ssh_key      = "${file(var.public_key_path)}"
  server_ssh_key_user = "${module.project_with_user.user_id}"
}

module "server-slave-1" {
  source = "../modules/selectel-vpc/server_remote_root_disk"

  # OpenStack auth.
  os_project_name  = "${var.os_project_name}"
  os_user_name     = "${var.os_user_name}"
  os_user_password = "${var.os_user_password}"
  os_domain_name   = "${var.sel_account}"
  os_auth_url      = "${var.os_auth_url}"
  os_region        = "${var.os_region}"

  # OpenStack Instance parameters.
  server_name         = "${format("%s-%d", var.slave_server_name, 1)}"
  server_zone         = "${var.server_zone}"
  server_vcpus        = "${var.server_vcpus}"
  server_ram_mb       = "${var.server_ram_mb}"
  server_root_disk_gb = "${var.server_root_disk_gb}"
  server_image_name   = "${var.server_image_name}"
  server_ssh_key      = "${file(var.public_key_path)}"
  server_ssh_key_user = "${module.project_with_user.user_id}"
}

module "server-slave-2" {
  source = "../modules/selectel-vpc/server_remote_root_disk"

  # OpenStack auth.
  os_project_name  = "${var.os_project_name}"
  os_user_name     = "${var.os_user_name}"
  os_user_password = "${var.os_user_password}"
  os_domain_name   = "${var.sel_account}"
  os_auth_url      = "${var.os_auth_url}"
  os_region        = "${var.os_region}"

  # OpenStack Instance parameters.
  server_name         = "${format("%s-%d", var.slave_server_name, 2)}"
  server_zone         = "${var.server_zone}"
  server_vcpus        = "${var.server_vcpus}"
  server_ram_mb       = "${var.server_ram_mb}"
  server_root_disk_gb = "${var.server_root_disk_gb}"
  server_image_name   = "${var.server_image_name}"
  server_ssh_key      = "${file(var.public_key_path)}"
  server_ssh_key_user = "${module.project_with_user.user_id}"
}

module "server-srv-1" {
  source = "../modules/selectel-vpc/server_remote_root_disk"

  # OpenStack auth.
  os_project_name  = "${var.os_project_name}"
  os_user_name     = "${var.os_user_name}"
  os_user_password = "${var.os_user_password}"
  os_domain_name   = "${var.sel_account}"
  os_auth_url      = "${var.os_auth_url}"
  os_region        = "${var.os_region}"

  # OpenStack Instance parameters.
  server_name         = "${format("%s-%d", var.srv_server_name, 1)}"
  server_zone         = "${var.server_zone}"
  server_vcpus        = "${var.server_vcpus}"
  server_ram_mb       = "${var.server_ram_mb}"
  server_root_disk_gb = "${var.server_root_disk_gb}"
  server_image_name   = "${var.server_image_name}"
  server_ssh_key      = "${file(var.public_key_path)}"
  server_ssh_key_user = "${module.project_with_user.user_id}"
}
