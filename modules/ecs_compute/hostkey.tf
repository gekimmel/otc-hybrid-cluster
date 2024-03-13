resource "opentelekomcloud_compute_keypair_v2" "keypair_lsf_nodes" {
  name       = "lsf-keypair-lsf-nodes"
  public_key = file(pathexpand("~/.ssh/id_rsa_lsf.pub"))
}

