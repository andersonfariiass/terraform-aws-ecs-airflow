################################################################################
# Global                                                                       # 
################################################################################

output "aws_account_id" {
  description = "Conta onde será feito deploy do terraform"
  value       = data.aws_caller_identity.current.account_id
}

################################################################################
# Cluster                                                                      # 
################################################################################

output "cluster_id" {
  description = "ID do Cluster ECS"
  value       = module.ecs_cluster.cluster_id
}

output "cluster_name" {
  description = "Nome que identifica o cluster"
  value       = module.ecs_cluster.cluster_name
}

# output "task_exec_iam_role_name" {
#   description = " Nome da Task execution IAM role"
#   value       = module.ecs_cluster.task_exec_iam_role_name
# }

################################################################################
# ECS Services                                                                 # 
################################################################################

# output "services" {
#   description = "Map of services created and their attributes"
#   value       = module.ecs_service_airflow_web
# }

################################################################################
# RDS                                                                          # 
################################################################################

output "db_instance_identifier" {
  description = "Identificador de instância RDS"
  value       = module.rds.db_instance_identifier
}
output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.rds.db_instance_endpoint
}

################################################################################
# AWS Secret                                                                   # 
################################################################################

output "secret_name" {
  description = "Nome do secret criado para o armazenar user e senha do RDS"
  value       = aws_secretsmanager_secret.rds.name
}

output "secret_id" {
  description = "ID do secret criado para o armazenar usario e senha do RDS"
  value       = aws_secretsmanager_secret.rds.id
}

output "secret_arn" {
  description = "The ARN of the secret"
  value       = aws_secretsmanager_secret.rds.arn
}