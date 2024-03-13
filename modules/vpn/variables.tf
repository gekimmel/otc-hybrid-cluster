
variable name {
  type        = string
  description = "prefix for resource names"
}

variable tags {
  type        = map(string)
  description = "common tag set for project resources"
}

variable psk {
  type        = string
  description = "pre shared key for vpn tunnel"
}

variable dpd {
  type        = bool
  description = "dead peer detection (true = hold (default) false = disabled)"
  default     = true
}

variable local_router {
  type        = string
  description = "VPC id of the vpnaas service"
}

variable local_subnets {
  type        = set(string)
  description = "local subnet CIDR ranges"
}

variable remote_gateway {
  type        = string
  description = "remote endpoint IPv4 address"
}

variable remote_subnets {
  type        = set(string)
  description = "remote subnet CIDR ranges"
}

#IKE policy parameters for the VPN tunnel:
variable vpn_ike_policy_dh_algorithm {
  type        = string
  default     = "group14"
  description = "diffie-Hellman key exchange algorithm"
}

variable vpn_ike_policy_auth_algorithm {
  type        = string
  default     = "sha2-256"
  description = "authentication hash algorithm"
}

variable vpn_ike_policy_encryption_algorithm {
  type        = string
  default     = "aes-128"
  description = "encryption algorithm"
}

variable vpn_ike_policy_lifetime {
  type        = number
  description = "lifetime of the security association in seconds"
  default     = 86400
}

#IPSec policy parameters for the VPN tunnel:
variable vpn_ipsec_policy_protocol {
  type        = string
  default     = "esp"
  description = "the security protocol used for IPSec to transmit and encapsulate user data"
}

variable vpn_ipsec_policy_auth_algorithm {
  type        = string
  default     = "sha2-256"
  description = "authentication hash algorithm"
}

variable vpn_ipsec_policy_encryption_algorithm {
  type        = string
  default     = "aes-128"
  description = "encryption algorithm"
}

variable vpn_ipsec_policy_lifetime {
  type        = number
  description = "lifetime of the security association in seconds"
  default     = 3600
}

variable vpn_ipsec_policy_pfs {
  type        = string
  default     = "group14"
  description = "the perfect forward secrecy mode"
}

