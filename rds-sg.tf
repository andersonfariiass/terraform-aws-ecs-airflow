module "rds_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  #for_each = { for db in local.workspace.rds.dbs : db.name => db }

  name        = "${local.name_prefix}-${local.workspace.rds.dbs.security_group.name_suffix}"
  description = "Security group para acesso ao postgres airflow"
  vpc_id      = module.vpc.vpc_id

  # ingress_cidr_blocks = ["10.0.0.0/16"]
  # ingress_rules       = ["postgresql-tcp"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "postgresql-tcp"
      description              = "Acesso ecs service airflow"
      source_security_group_id = module.ecs_services_sg.security_group_id #join("", flatten([for s in module.ecs_service_airflow_web : s.security_group_id]))
    },
  ]
  tags = local.tags
}