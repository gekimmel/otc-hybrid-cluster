variable subnet_id {
  type        = string
  description = "ID of the subnet"
}

variable lsf_host_name {
  type        = string
  description = "host names of the ecs instances"
}

variable ecs_image_name {
  type        = string
  default     = "Standard_CentOS_Stream_latest"
  description = "image name for lsf nodes"
}

variable lsf_flavor {
  type        = string
  default     = "s3.xlarge.1"
  description = "flavor type for lsf nodes"
}
