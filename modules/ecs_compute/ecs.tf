data "opentelekomcloud_images_image_v2" "lsf_image" {
  name = var.ecs_image_name
}

resource "opentelekomcloud_compute_instance_v2" "lsf_node" {
  for_each        = var.lsf_host_name
  name            = each.value
  image_id        = data.opentelekomcloud_images_image_v2.lsf_image.id
  flavor_id       = var.lsf_flavor
  key_pair        = opentelekomcloud_compute_keypair_v2.keypair_lsf_nodes.name
  security_groups = [ "lsf_secgroup_intern" ]

  network {
    uuid = var.subnet_id
  }

  block_device {
    uuid                  = data.opentelekomcloud_images_image_v2.lsf_image.id
    source_type           = "image"
    destination_type      = "volume"
    boot_index            = 0
    volume_size           = 15
    delete_on_termination = true
  }
}

output "lsf_nodes_list" {
  value = [
    for instance_key, instance in opentelekomcloud_compute_instance_v2.lsf_node :
    {
      name     = instance.name
      network  = [{
        fixed_ip_v4 = instance.network.0.fixed_ip_v4
      }]
    }
  ]
}

