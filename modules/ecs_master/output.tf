output "lsf_master_ip" {
  value = opentelekomcloud_networking_floatingip_associate_v2.floatingip_associate_lsf_master.floating_ip
}

output "access_ip_v4" {
  value = opentelekomcloud_compute_instance_v2.lsf_node.access_ip_v4
}

output "lsf_nodes_list" {
  value = [
    {
      name     = opentelekomcloud_compute_instance_v2.lsf_node.name
      network  = [{
        fixed_ip_v4 = opentelekomcloud_compute_instance_v2.lsf_node.network.0.fixed_ip_v4
      }]
    }
  ]
}

