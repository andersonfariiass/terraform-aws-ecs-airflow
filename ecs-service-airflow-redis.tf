module "ecs_service_airflow_redis" {
  source   = "terraform-aws-modules/ecs/aws//modules/service"
  version  = "5.11.3"
  for_each = { for svc in local.workspace.service_redis : svc.name => svc }

  name                   = "${local.name_prefix}-${each.value.name}"
  cluster_arn            = module.ecs_cluster.cluster_arn
  cpu                    = try(each.value.cpu, 1024)
  memory                 = try(each.value.memory, 2048)
  launch_type            = upper(each.value.launch_type)
  enable_execute_command = true
  capacity_provider_strategy = [
    {
      weight            = each.value.weight
      base              = each.value.base
      capacity_provider = upper(each.value.capacity_provider)
    }
  ]
  # Container definition(s)
  container_definitions = {
    (each.value.name) = {
      cpu       = try(each.value.cpu, 1024)
      memory    = try(each.value.memory, 2048)
      essential = true
      image     = each.value.image
      port_mappings = can(each.value.containerport) ? [
        {
          name          = each.value.name
          containerPort = each.value.containerport
          hostPort      = each.value.containerport
          protocol      = each.value.protocol
        }
      ] : []

      command = can(each.value.command) ? [each.value.command] : []
      runtimePlatform = [
        {
          cpuArchitecture       = "X86_64"
          operatingSystemFamily = "LINUX"
        }
      ]
      environment = [
        {
          "name" : "ALLOW_EMPTY_PASSWORD",
          "value" : "yes"
        }
      ]
      readonly_root_filesystem  = false
      enable_cloudwatch_logging = true
      memory_reservation        = 100
    }
    #tags = local.tags
  }
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 5

  service_connect_configuration = {
    namespace = "airflow"
    service = {
      client_alias = {
        port     = each.value.containerport
        dns_name = each.value.name
      }
      port_name      = each.value.name
      discovery_name = each.value.name
    }
  }

  # load_balancer = {
  #   service = {
  #     target_group_arn = data.aws_lb_target_group.tg_airflow.arn
  #     container_name   = each.value.name
  #     container_port   = each.value.containerport
  #   }
  # }
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = ["${module.ecs_services_sg.security_group_id}"]

  service_tags = {
    "Service" = "${each.value.name}-${var.env}"
  }
  depends_on = [aws_service_discovery_http_namespace.airflow, module.rds]
  tags       = local.tags
}