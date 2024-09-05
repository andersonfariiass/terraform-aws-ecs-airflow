resource "random_password" "rds" {
  length           = 16
  special          = true
  override_special = "!()*"
}

resource "bcrypt_hash" "rds" {
  cleartext = random_password.rds.result
}

resource "aws_secretsmanager_secret" "rds" {
  name                    = "${local.name_prefix}-${local.workspace.rds.dbs.name}"
  recovery_window_in_days = 0 # Set to zero for this example to force delete during Terraform destroy
  tags = merge(
    local.tags,
    local.secret_tags
  )
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode({
    username             = "${local.workspace.rds.dbs.user}"
    password             = random_password.rds.result
    db_connection_string = "postgresql+psycopg2://${local.db_connection_string}"
    db_celery_result     = "db+postgresql://${local.db_connection_string}"
  })
}