resource "opentelekomcloud_networking_secgroup_v2" "lsf_secgroup_master" {
  name        = "lsf_secgroup_extern"
  description = "allow traffic for master nodes"
}

resource "opentelekomcloud_networking_secgroup_v2" "lsf_secgroup_compute" {
  name        = "lsf_secgroup_intern"
  description = "allow traffic for compute nodes"
}

# security group rules for master host

resource "opentelekomcloud_networking_secgroup_rule_v2" "secgroup_rule_master_all" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_ip_prefix  = one(var.remote_subnets)
  security_group_id = opentelekomcloud_networking_secgroup_v2.lsf_secgroup_master.id
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "secgroup_rule_master_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = opentelekomcloud_networking_secgroup_v2.lsf_secgroup_master.id
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "secgroup_rule_master_sg" {
  for_each          = tomap({ "sg_master" = opentelekomcloud_networking_secgroup_v2.lsf_secgroup_master.id, "sg_compute" = opentelekomcloud_networking_secgroup_v2.lsf_secgroup_compute.id })
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = ""
  remote_group_id   = each.value
  security_group_id = opentelekomcloud_networking_secgroup_v2.lsf_secgroup_master.id
}

# security group rules for compute hosts

resource "opentelekomcloud_networking_secgroup_rule_v2" "secgroup_rule_compute_all" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_ip_prefix  = one(var.remote_subnets)
  security_group_id = opentelekomcloud_networking_secgroup_v2.lsf_secgroup_compute.id
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "secgroup_rule_compute_sg" {
  for_each          = tomap({ "sg_master" = opentelekomcloud_networking_secgroup_v2.lsf_secgroup_master.id, "sg_compute" = opentelekomcloud_networking_secgroup_v2.lsf_secgroup_compute.id })
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = ""
  remote_group_id   = each.value
  security_group_id = opentelekomcloud_networking_secgroup_v2.lsf_secgroup_compute.id
}

