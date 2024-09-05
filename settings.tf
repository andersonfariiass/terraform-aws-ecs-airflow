################################################################################
# Paramentro para leitura do envs/yaml correto                                 # 
################################################################################
locals {
  env       = yamldecode(file("./envs/${var.env}.yaml"))
  workspace = local.env["workspace"]["${var.env}"]
}