variable dns_zone {
  type        = string
  default     = "lsf.private"
  description = "name of the private DNS zone"
}

variable region {
  type        = string
  description = "region code for dns zone"
}

variable vpc_id {
  type        = string
  description = "VPC ID bound to DNS zone"
}

variable lsf_master_list {
  type        = list(object({
    name    = string
    network = list(object({
      fixed_ip_v4 = string
    }))
  }))
  description = "list of lsf master instances"
}

variable lsf_compute_private_list {
  type        = list(object({
    name    = string
    network = list(object({
      fixed_ip_v4 = string
    }))
  }))
  description = "list of lsf compute private instances"
}

variable lsf_compute_public_list {
  type        = list(object({
    name    = string
    network = list(object({
      fixed_ip_v4 = string
    }))
  }))
  description = "list of lsf compute public instances"
}
