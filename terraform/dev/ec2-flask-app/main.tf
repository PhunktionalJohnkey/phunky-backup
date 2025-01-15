terraform {
  backend "s3" {
    bucket         = "phunkytech-state-security-web-waf"
    dynamodb_table = "phunkytech-state-security-web-waf"
    encrypt        = true
    key            = "dev-flask-app.tfstate"
    region         = "eu-west-2"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "phunkytech-state-security-web-waf"
    key    = "dev-network.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    bucket = "phunkytech-state-security-web-waf"
    key    = "dev-alb.tfstate"
    region = var.region
  }
}

provider "aws" {
  allowed_account_ids = [var.account_id]
  region              = var.region
}
