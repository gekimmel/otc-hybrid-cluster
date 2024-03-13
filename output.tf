output "lsf_master_ip" {
  value       = module.ecs_lsf_master.lsf_master_ip
  description = "Public IP of lsf-master"
}
