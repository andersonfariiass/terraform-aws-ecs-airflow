provider "aws" {
  region  = local.region
  profile = "my-profile"
}

provider "bcrypt" {}