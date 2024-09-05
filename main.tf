module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.11.3"

  cluster_name = "${local.name_prefix}-${local.workspace.cluster_ecs.name}"

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
        base   = 20
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  cluster_settings = var.cluster_settings

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/${local.workspace.cluster_ecs.name}"
      }
    }
  }

  # tasks_iam_role_name        = "${local.workspace.cluster_ecs.name}-tasks"
  # tasks_iam_role_description = "Tasks IAM role for ${local.workspace.cluster_ecs.name}"

  tags                      = local.tags
  cloudwatch_log_group_tags = local.tags
}