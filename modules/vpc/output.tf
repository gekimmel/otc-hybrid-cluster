output "subnet_cidr" {
  value = var.subnet_cidr
}

output "vpc_id" {
  value = opentelekomcloud_vpc_v1.vpc_1.id
}

output "subnet_id" {
  value = opentelekomcloud_vpc_subnet_v1.subnet_1.id
}

