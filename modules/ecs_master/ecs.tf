data "opentelekomcloud_images_image_v2" "lsf_image" {
  name = var.ecs_image_name
}

resource "opentelekomcloud_compute_instance_v2" "lsf_node" {
  name            = var.lsf_host_name
  image_id        = data.opentelekomcloud_images_image_v2.lsf_image.id
  flavor_id       = var.lsf_flavor
  key_pair        = opentelekomcloud_compute_keypair_v2.keypair_lsf_nodes.name
  security_groups = [ "lsf_secgroup_extern" ]

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

  user_data = "${file("${path.module}/cloud-init.sh")}"
}

resource "opentelekomcloud_networking_floatingip_associate_v2" "floatingip_associate_lsf_master" {
  floating_ip = opentelekomcloud_vpc_eip_v1.master_eip.publicip[0].ip_address
  port_id     = opentelekomcloud_compute_instance_v2.lsf_node.network[0].port
}

