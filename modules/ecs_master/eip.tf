resource "opentelekomcloud_vpc_eip_v1" "master_eip" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "${var.lsf_host_name}-bandwidth"
    size        = 100
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

