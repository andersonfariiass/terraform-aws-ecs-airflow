# terraform-aws-ecs-airflow
Projeto para Deploy de um cluster ECS com o Apache airflow.

## Introdução
Esse repositorio é responsável por provisionar cluster ECS com um deploy inicial do Apache Airflow.
O codigo provisiona os seguintes recursos:

- ECS Cluster
- ECS Services
- ECS Task Definition (Padrão inicial)
- AWS Secret Manager (Armazena user/password do RDS e string de conexão do banco de dados e do redis)
- LoadBalancer
- RDS Postgresql
- RDS Security Group
- Deploy inicial do apache Airflow

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.1.5 |
| aws | >= 4.20.1 |
| bcrypt | >= 0.1.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| alb | terraform-aws-modules/alb/aws | 9.9.0 |
| ecs\_cluster | terraform-aws-modules/ecs/aws | 5.11.3 |
| ecs\_service\_airflow\_init | terraform-aws-modules/ecs/aws//modules/service | 5.11.3 |
| ecs\_service\_airflow\_redis | terraform-aws-modules/ecs/aws//modules/service | 5.11.3 |
| ecs\_service\_airflow\_scheduler | terraform-aws-modules/ecs/aws//modules/service | 5.11.3 |
| ecs\_service\_airflow\_web | terraform-aws-modules/ecs/aws//modules/service | 5.11.3 |
| ecs\_service\_airflow\_worker | terraform-aws-modules/ecs/aws//modules/service | 5.11.3 |
| ecs\_services\_sg | terraform-aws-modules/security-group/aws | 5.1.2 |
| rds | terraform-aws-modules/rds/aws | 6.7.0 |
| rds\_sg | terraform-aws-modules/security-group/aws | 5.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_service_discovery_http_namespace.airflow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_http_namespace) | resource |
| [bcrypt_hash.rds](https://registry.terraform.io/providers/viktorradnai/bcrypt/latest/docs/resources/hash) | resource |
| [random_password.rds](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_lb_target_group.tg_airflow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb_target_group) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnet_ids.subnet_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_subnets.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.subnet_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpcs.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpcs) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloudwatch\_log\_group\_retention\_in\_days | Número de dias para reter eventos de log | `number` | `45` | no |
| cloudwatch\_log\_group\_tags | Um mapa de tags adicionais para adicionar ao grupo de log criado | `map(string)` | `{}` | no |
| cluster\_name | Nome do cluster ECS | `string` | `""` | no |
| cluster\_settings | Lista de blocos de configuração com configurações de cluster. Por exemplo, isso pode ser usado para habilitar o CloudWatch Container Insights para um cluster | `any` | ```[ { "name": "containerInsights", "value": "disabled" } ]``` | no |
| env | Identificador do Workspace/ambiente | `string` | `"prd"` | no |
| password | Senha para o usuário mestre do BD RDS. Observe que isso pode aparecer em logs e será armazenado no arquivo de estado.   A senha fornecida não será usada se `manage_master_user_password` estiver definido como true | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws\_account\_id | Conta onde será feito deploy do terraform |
| cluster\_id | ID do Cluster ECS |
| cluster\_name | Nome que identifica o cluster |
| db\_instance\_endpoint | The connection endpoint |
| db\_instance\_identifier | Identificador de instância RDS |
| secret\_arn | The ARN of the secret |
| secret\_id | ID do secret criado para o armazenar usario e senha do RDS |
| secret\_name | Nome do secret criado para o armazenar user e senha do RDS |
<!-- END_TF_DOCS -->