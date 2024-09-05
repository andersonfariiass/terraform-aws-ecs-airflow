module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.7.0"

  #for_each = { for db in local.workspace.rds.dbs : db.name => db }

  identifier           = "${local.name_prefix}-${local.workspace.rds.dbs.name}"
  engine               = local.workspace.rds.dbs.engine
  engine_version       = local.workspace.rds.dbs.engine_version
  major_engine_version = local.workspace.rds.dbs.major_engine_version
  family               = local.workspace.rds.dbs.family
  instance_class       = local.workspace.rds.dbs.instance_class

  storage_type                = try(local.workspace.rds.dbs.storage_type, "gp3")
  allocated_storage           = local.workspace.rds.dbs.allocated_storage
  max_allocated_storage       = local.workspace.rds.dbs.max_allocated_storage
  db_name                     = local.workspace.rds.dbs.db_name
  manage_master_user_password = false
  username                    = local.workspace.rds.dbs.user
  password                    = random_password.rds.result #jsondecode(aws_secretsmanager_secret_version.rds[each.key].secret_string)["password"] #random_password.rds.result
  port                        = try(local.workspace.rds.dbs.port, 5432)
  create_db_subnet_group      = local.workspace.rds.dbs.create_db_subnet_group
  publicly_accessible         = false
  subnet_ids                  = module.vpc.private_subnets
  vpc_security_group_ids      = ["${module.rds_sg.security_group_id}"] #[join("", flatten([for s in module.rds_sg : s.security_group_id]))]

  tags = local.tags
}
