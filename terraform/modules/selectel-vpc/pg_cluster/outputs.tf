output "floating_ip" {
  value = "${module.floatingip.floatingip_address}"
}

output "instance_port_id" {
  value = "${openstack_networking_port_v2.port_1.id}"
}
