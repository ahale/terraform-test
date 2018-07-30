provider "aws" {
  region = "${var.region}"
}

variable "region" {
  default = "eu-west-1"
}

variable "stage" {
  default = "dev"
}

variable "project" {
  default = "testapp"
}

module "app_cognito" {
  source = "../../modules/cognito"
  name   = "${data.template_file.app_cognito_name.rendered}"
  region = "${var.region}"
}

module "kibana_cognito" {
  source = "../../modules/cognito"
  name   = "${data.template_file.kibana_cognito_name.rendered}"
}

module "elasticsearch" {
  source                   = "../../modules/elasticsearch"
  domain_name              = "${data.template_file.elasticsearch_domain.rendered}"
  region                   = "${var.region}"
  instance_type            = "t2.small.elasticsearch"
  instance_count           = 1
  dedicated_master_enabled = false
  ebs_enabled              = true
  volume_type              = "gp2"
  volume_size              = 10
  encrypted_at_rest        = false
  admin_arn                = "${module.kibana_cognito.idp_authenticated_role_policy_arn}"
  readonly_arn             = "${module.app_cognito.idp_unauthenticated_role_policy_arn}"
}

module "buckets" {
  prefix = "${data.template_file.project_name.rendered}"
}
