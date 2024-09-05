################################################################################
# Cluster                                                                      # 
################################################################################

variable "cluster_name" {
  description = "Nome do cluster ECS"
  type        = string
  default     = ""
}

variable "cluster_settings" {
  description = "Lista de blocos de configuração com configurações de cluster. Por exemplo, isso pode ser usado para habilitar o CloudWatch Container Insights para um cluster"
  type        = any
  default = [
    {
      name  = "containerInsights"
      value = "disabled"
    }
  ]
}

################################################################################
# CloudWatch Log Group
################################################################################
variable "cloudwatch_log_group_retention_in_days" {
  description = "Número de dias para reter eventos de log"
  type        = number
  default     = 45
}

variable "cloudwatch_log_group_tags" {
  description = "Um mapa de tags adicionais para adicionar ao grupo de log criado"
  type        = map(string)
  default     = {}
}
################################################################################
# Bucket                                                                       #
################################################################################
# variable "bucket_name" {
#   description = "Nome do Bucket para DAGS do Airflow"
#   type        = string
# }

################################################################################
# RDS                                                                          # 
################################################################################
variable "password" {
  description = <<EOF
  Senha para o usuário mestre do BD RDS. Observe que isso pode aparecer em logs e será armazenado no arquivo de estado.
  A senha fornecida não será usada se `manage_master_user_password` estiver definido como true
  EOF
  type        = string
  default     = null
  sensitive   = true
}

################################################################################
# ENV                                                                          # 
################################################################################
variable "env" {
  description = "Identificador do Workspace/ambiente"
  type        = string
  default     = "prd"
}