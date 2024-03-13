
module "vpc_private" {
  providers = {
    opentelekomcloud = opentelekomcloud.otc_private
  }

  source      = "./modules/vpc"
  vpc_cidr    = var.vpc_private_cidr
  subnet_cidr = var.subnet_private_cidr
}

module "vpc_public" {
  providers = {
    opentelekomcloud = opentelekomcloud.otc_public
  }

  source      = "./modules/vpc"
  vpc_cidr    = var.vpc_public_cidr
  subnet_cidr = var.subnet_public_cidr
}

resource "random_password" "psk_vpn" {
  length      = 32
  special     = false
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
}

module "vpn_tunnel_private" {
  providers = {
    opentelekomcloud = opentelekomcloud.otc_private
  }

  source         = "./modules/vpn"
  name           = "lsf-vpn"
  psk            = random_password.psk_vpn.result
  remote_gateway = module.vpn_tunnel_public.vpn_tunnel_gateway
  remote_subnets = [ module.vpc_public.subnet_cidr ]
  local_router   = module.vpc_private.vpc_id
  local_subnets  = [ module.vpc_private.subnet_cidr ]
  tags           = var.resource_tags
}

module "vpn_tunnel_public" {
  providers = {
    opentelekomcloud = opentelekomcloud.otc_public
  }

  source         = "./modules/vpn"
  name           = "lsf-vpn"
  psk            = random_password.psk_vpn.result
  remote_gateway = module.vpn_tunnel_private.vpn_tunnel_gateway
  remote_subnets = [ module.vpc_private.subnet_cidr ]
  local_router   = module.vpc_public.vpc_id
  local_subnets  = [ module.vpc_public.subnet_cidr ]
  tags           = var.resource_tags
}

module "ecs_lsf_master" {
  providers = {
    opentelekomcloud = opentelekomcloud.otc_public
  }

  source          = "./modules/ecs_master"
  lsf_host_name   = var.master_host_name
  subnet_id       = module.vpc_public.subnet_id
}

module "ecs_lsf_compute_private" {
  providers = {
    opentelekomcloud = opentelekomcloud.otc_private
  }

  source          = "./modules/ecs_compute"
  lsf_host_name   = var.private_comute_host_names
  subnet_id       = module.vpc_private.subnet_id
}

module "ecs_lsf_compute_public" {
  providers = {
    opentelekomcloud = opentelekomcloud.otc_public
  }

  source          = "./modules/ecs_compute"
  lsf_host_name   = var.public_comute_host_names
  subnet_id       = module.vpc_public.subnet_id
}

module "dns_private" {
  providers = {
    opentelekomcloud = opentelekomcloud.otc_private
  }

  source                   = "./modules/dns"
  region                   = var.region_private
  vpc_id                   = module.vpc_private.vpc_id
  lsf_master_list          = module.ecs_lsf_master.lsf_nodes_list
  lsf_compute_private_list = module.ecs_lsf_compute_private.lsf_nodes_list
  lsf_compute_public_list  = module.ecs_lsf_compute_public.lsf_nodes_list
}

module "dns_public" {
  providers = {
    opentelekomcloud = opentelekomcloud.otc_public
  }

  source                   = "./modules/dns"
  region                   = var.region_public
  vpc_id                   = module.vpc_public.vpc_id
  lsf_master_list          = module.ecs_lsf_master.lsf_nodes_list
  lsf_compute_private_list = module.ecs_lsf_compute_private.lsf_nodes_list
  lsf_compute_public_list  = module.ecs_lsf_compute_public.lsf_nodes_list
}

module "ansible_inventory" {
  source                   = "./modules/ansible_inventory"
  lsf_master_list          = module.ecs_lsf_master.lsf_nodes_list
  lsf_compute_private_list = module.ecs_lsf_compute_private.lsf_nodes_list
  lsf_compute_public_list  = module.ecs_lsf_compute_public.lsf_nodes_list
}

