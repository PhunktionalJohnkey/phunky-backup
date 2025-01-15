terraform {
  backend "s3" {
    bucket         = "phunkytech-state-security-web-waf"
    dynamodb_table = "phunkytech-state-security-web-waf"
    encrypt        = true
    key            = "dev-sns.tfstate"
    region         = "eu-west-2"
  }
}

provider "aws" {
  allowed_account_ids = [var.account_id]
  region              = var.region
}

module "sns_dev_alerts" {
  source = "../../modules/sns"

  account_id = var.account_id
  env        = var.env
  project    = var.project
  region     = var.region

  topic_name = "udemy-dev-alerts"

  subscriptions = {
    phunkytech = {
      protocol = "email"
      endpoint = "leyealexoni@gmail.com"
    },
  }
}
