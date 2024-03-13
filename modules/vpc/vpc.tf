resource "opentelekomcloud_vpc_v1" "vpc_1" {
  name = "lsf-vpc"
  cidr = var.vpc_cidr
}

resource "opentelekomcloud_vpc_subnet_v1" "subnet_1" {
  name       = "lsf-subnet-1"
  cidr       = var.subnet_cidr
  vpc_id     = opentelekomcloud_vpc_v1.vpc_1.id
  gateway_ip = cidrhost(var.subnet_cidr,1)
}

