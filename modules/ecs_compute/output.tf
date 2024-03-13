output "access_ip_v4" {
  value = [ for access_ip_v4 in opentelekomcloud_compute_instance_v2.lsf_node: access_ip_v4 ]
}

