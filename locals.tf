locals {
  region                  = "us-east-1"
  name_prefix             = "ecs-${var.env}"
  tg_name                 = "${local.name_prefix}-${local.workspace.loadbalancer.elbs[0].target_groups.name}"
  db_connection_string    = "${local.workspace.rds.dbs.user}:${random_password.rds.result}@${module.rds.db_instance_endpoint}/${local.workspace.rds.dbs.db_name}"
  redis_connection_string = "redis://:@${local.workspace.service_redis[0].name}:6379/0"

  tags = {
    IAC             = "SIM"
    AMBIENTE        = upper(var.env)
    TIME            = local.workspace.tags.time
    APLICACAO       = local.workspace.tags.aplicacao
  }

  secret_tags = {
    Descricao = "Secret RDS Airflow"
  }
}