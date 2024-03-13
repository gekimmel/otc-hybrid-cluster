terraform {
  required_version = ">= 1.0.0"
}

resource "local_file" "ansible_inventory" {
  content  = templatefile("${path.module}/hosts.tftpl",
    {
      lsf_master_nodes          = var.lsf_master_list
      lsf_compute_private_nodes = var.lsf_compute_private_list
      lsf_compute_public_nodes  = var.lsf_compute_public_list
    }
  )
  filename = "${path.root}/ansible/hosts"
}
