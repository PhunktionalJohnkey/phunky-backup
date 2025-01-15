terraform {
  backend "s3" {
    bucket         = "phunkytech-state-security-web-waf"
    dynamodb_table = "phunkytech-state-security-web-waf"
    encrypt        = true
    key            = "dev-alb.tfstate"
    region         = "eu-west-2"
  }
}

provider "aws" {
  allowed_account_ids = [var.account_id]
  region              = var.region
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "phunkytech-state-security-web-waf"
    key    = "dev-network.tfstate"
    region = var.region
  }
}

module "alb" {
  source = "../../modules/alb"

  account_id = var.account_id
  env        = var.env
  project    = var.project
  region     = var.region

  vpc        = data.terraform_remote_state.network.outputs.vpc
  lb_subnets = data.terraform_remote_state.network.outputs.subnets_public

  lb_sg         = data.terraform_remote_state.network.outputs.sg_alb
  lb_ssl_policy = "ELBSecurityPolicy-2016-08"
  main_domain   = "phunkytech.org"

  logs_enabled    = true
  logs_prefix     = "dev-flask"
  logs_bucket     = "dev-lb-flask-phunkytechlogs"
  logs_expiration = 90


  create_aliases = [
    {
      name = "flask"
      zone = "phunkytech.org"
    }
  ]

  waf_rules_override_action   = "count"
  custom_waf_rules            = true
  waf_secret_header_value     = "some_secret"
  ips_to_be_allowed = ["86.173.174.72/32"]

  alarm_sns_topic_name = "udemy-dev-alerts"
}
