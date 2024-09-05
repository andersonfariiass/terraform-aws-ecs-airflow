# ################################################################################
# # Criação do Cloud Map Namespace para o ECS Service Connect                    # 
# ################################################################################

resource "aws_service_discovery_http_namespace" "airflow" {
  name        = "airflow"
  description = "Namespace para comunicação entre containers do airflow no cluster ECS"
  tags_all    = local.tags
}