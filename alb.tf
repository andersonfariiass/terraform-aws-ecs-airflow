module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.9.0"

  for_each = { for elbs in local.workspace.loadbalancer.elbs : elbs.name => elbs }

  name                       = "${local.name_prefix}-${each.value.name}-${each.value.scheme}"
  load_balancer_type         = each.value.loadbalancer_type
  vpc_id                     = module.vpc.vpc_id
  subnets                    = module.vpc.public_subnets
  internal                   = each.value.internal
  enable_deletion_protection = try(each.value.deletion_protection, false)

  # Security Group
  security_group_ingress_rules = {
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS traffic airflow-web"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP traffic airflow-web"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.vpc.vpc_cidr_block
    }
  }

  listeners = {
    http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = each.value.certificate_arn
      forward = {
        target_group_key = ("${local.tg_name}")
      }
    }
  }

  target_groups = {
    ("${local.tg_name}") = {
      name                              = "${local.tg_name}"
      backend_protocol                  = each.value.target_groups.backend_protocol
      backend_port                      = each.value.target_groups.backend_port
      port                              = each.value.target_groups.backend_port
      target_type                       = each.value.target_groups.target_type
      deregistration_delay              = each.value.target_groups.deregistration_delay
      load_balancing_cross_zone_enabled = each.value.target_groups.load_balancing_cross_zone_enabled
      stickiness = {
        enable          = true
        type            = "lb_cookie"
        cookie_duration = 3600
      }

      health_check = {
        enabled             = true
        healthy_threshold   = each.value.target_groups.health_check.healthy_threshold
        interval            = each.value.target_groups.health_check.interval
        matcher             = each.value.target_groups.health_check.matcher
        path                = each.value.target_groups.health_check.path
        port                = each.value.target_groups.health_check.port
        protocol            = each.value.target_groups.health_check.protocol
        timeout             = each.value.target_groups.health_check.timeout
        unhealthy_threshold = each.value.target_groups.health_check.unhealthy_threshold
      }
      create_attachment = false
    }
  }
  tags = local.tags
}
