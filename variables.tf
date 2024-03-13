variable region_private {
  type        = string
  default     = "eu-ch2"
  description = "region identifier for private cloud"
}

variable region_public {
  type        = string
  default     = "eu-de"
  description = "region identifier for public cloud"
}

variable vpc_private_cidr {
  type        = string
  default     = "10.0.0.0/20"
  description = "IP range of private cloud VPC"
}

variable subnet_private_cidr {
  type        = string
  default     = "10.0.0.0/24"
  description = "IP range of private cloud subnet"
}

variable vpc_public_cidr {
  type        = string
  default     = "10.1.0.0/20"
  description = "IP range of public cloud VPC"
}

variable subnet_public_cidr {
  type        = string
  default     = "10.1.0.0/24"
  description = "IP range of public cloud subnet"
}

variable resource_tags {
  type        = map(string)
  default     = {
    project     = "lsf-cluster",
  }
  description = "tags to set for resources (we do not use tags for all resources, only when required)"
}

variable lsf_host_name {
  type        = set(string)
  default     = [ "lsf-host" ]
  description = "host names of the ecs instances"
}

variable master_host_name {
  type        = string
  default     = "lsf-master"
  description = "host name of the lsf-master instance"
}

variable private_comute_host_names {
  type        = set(string)
  default     = [ "lsf-comp-priv-1", "lsf-comp-priv-2", "lsf-comp-priv-3" ]
  description = "host names of the private compute instances"
}

variable public_comute_host_names {
  type        = set(string)
  default     = [ "lsf-comp-pub-1", "lsf-comp-pub-2", "lsf-comp-pub-3" ]
  description = "host names of the public compute instances"
}

variable img {
  type = string
  default = ""
  description = "name of the image to deploy ecs instances"
}

