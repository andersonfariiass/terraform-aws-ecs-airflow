module "ecs_services_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "${local.name_prefix}-${local.workspace.cluster_ecs.security_group.name_suffix}"
  description = "Security group ECS Services"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "ECS Services SG"
      cidr_blocks = "10.0.0.0/16"
    },
  ]
  #egress_cidr_blocks = ["0.0.0.0/0"]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound traffic"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = local.tags
}