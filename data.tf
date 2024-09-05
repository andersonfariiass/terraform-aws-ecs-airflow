# Find the user currently in use by AWS
data "aws_caller_identity" "current" {}

# Region in which to deploy the solution
data "aws_region" "current" {}

data "aws_vpcs" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["vpc-teste"]
  }
}

data "aws_vpc" "this" {
  count = length(data.aws_vpcs.vpc.ids)
  id    = tolist(data.aws_vpcs.vpc.ids)[count.index]
}

data "aws_subnet_ids" "subnet_ids" {
  vpc_id = data.aws_vpcs.vpc.ids[0]
}
data "aws_subnets" "subnet_id" {
  for_each = data.aws_subnet_ids.subnet_ids.ids
  id       = each.value
}

data "aws_subnets" "private_subnet" {
  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
  depends_on = [ module.vpc ]
}

data "aws_subnets" "public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
  depends_on = [ module.vpc ]
}

data "aws_lb_target_group" "tg_airflow" {
  name       = local.tg_name
  depends_on = [module.alb]
}

#

# data "aws_secretsmanager_secret_version" "rds" {
#   secret_id = "${module.secrets_manager.secret_id}"
# }