
resource "opentelekomcloud_dns_zone_v2" "lsf_private" {
  name        = var.dns_zone
  description = "DNS private zone for LSF cluster"
  email       = "dl-otc-domains@telekom.de"
  ttl         = 3000
  type        = "private"

  router {
    router_id     = var.vpc_id
    router_region = var.region
  }
}

resource "opentelekomcloud_dns_recordset_v2" "arecord_master" {
  for_each    = { for index, instance in var.lsf_master_list : index => instance }
  zone_id     = opentelekomcloud_dns_zone_v2.lsf_private.id
  name        = join("", [each.value.name, ".", var.dns_zone, "."])
  description = join("", ["lsf cluster host ", each.value.name])
  ttl         = 3000
  type        = "A"
  records     = each.value.network.*.fixed_ip_v4
}

resource "opentelekomcloud_dns_recordset_v2" "arecord_compute_private" {
  for_each    = { for index, instance in var.lsf_compute_private_list : index => instance }
  zone_id     = opentelekomcloud_dns_zone_v2.lsf_private.id
  name        = join("", [each.value.name, ".", var.dns_zone, "."])
  description = join("", ["lsf cluster host ", each.value.name])
  ttl         = 3000
  type        = "A"
  records     = each.value.network.*.fixed_ip_v4
}

resource "opentelekomcloud_dns_recordset_v2" "arecord_compute_public" {
  for_each    = { for index, instance in var.lsf_compute_public_list : index => instance }
  zone_id     = opentelekomcloud_dns_zone_v2.lsf_private.id
  name        = join("", [each.value.name, ".", var.dns_zone, "."])
  description = join("", ["lsf cluster host ", each.value.name])
  ttl         = 3000
  type        = "A"
  records     = each.value.network.*.fixed_ip_v4
}
