terraform {
  # Версия terraform
  required_version = "~> 0.11.12"
}

provider "selectel" {
  token = "${var.OS_X_TOKEN}"
}

# Create the main project with user.
# This module should be applied first:
# terraform apply -target=module.project_with_user
module "project_with_user" {
  source = "../modules/selectel-vpc/project_with_user"

  project_name  = "${var.OS_PROJECT_NAME}"
  user_name     = "${var.OS_USERNAME}"
  user_password = "${var.OS_PASSWORD}"
}

module "pg-cluster" {
  source = "../modules/selectel-vpc/pg_cluster"

  # OpenStack auth.
  os_project_name  = "${var.OS_PROJECT_NAME}"
  os_user_name     = "${var.OS_USERNAME}"
  os_user_password = "${var.OS_PASSWORD}"
  os_domain_name   = "${var.OS_USER_DOMAIN_NAME}"
  os_auth_url      = "${var.OS_AUTH_URL}"
  os_region        = "${var.OS_REGION}"

  # OpenStack Instance parameters.
  srv_instance_prefix_name    = "${var.srv_instance_prefix_name}"
  master_instance_count       = "${var.master_instance_count}"
  master_instance_prefix_name = "${var.master_instance_prefix_name}"
  slave_instance_count        = "${var.slave_instance_count}"
  slave_instance_prefix_name  = "${var.slave_instance_prefix_name}"

  server_zone         = "${var.instance_zone}"
  server_vcpus        = "${var.instance_vcpus}"
  server_ram_mb       = "${var.instance_ram_mb}"
  server_root_disk_gb = "${var.instance_root_disk_gb}"
  server_image_name   = "${var.instance_image_name}"
  server_ssh_key      = "${file(var.public_key_path)}"
  server_ssh_key_user = "${module.project_with_user.user_id}"
}
