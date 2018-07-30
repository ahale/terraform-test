variable "name" {}

variable "region" {
  default = "eu-west-1"
}

variable "allow_unauthenticated_identities" {
  default = false
}

data "template_file" "idp_name" {
  template = "${format("idp_%s", var.name)}"
}

data "template_file" "idp_unauthenticated_role_name" {
  template = "${format("idp_unauthenticated_role_%s", var.name)}"
}

data "template_file" "idp_authenticated_role_name" {
  template = "${format("idp_authenticated_role_%s", var.name)}"
}

data "template_file" "userpool_name" {
  template = "${format("userpool_%s", var.name)}"
}

data "template_file" "userpool_lambda_name" {
  template = "${format("%s_userpool_event_lambda", var.name)}"
}

data "template_file" "appclient_name" {
  template = "${format("appclient_%s", var.name)}"
}

data "template_file" "appclient_domain_name" {
  template = "${format("authurl-%s", var.name)}"
}

variable "userpool_mfa_configuration" {
  default = "OFF"
}

variable "userpool_password_policy" {
  default = [{
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }]
}

variable "userpool_allow_admin_create_user_only" {
  default = true
}

variable "appclient_generate_secret" {
  default = false
}

variable "search" {
  default = "_"
}

variable "replace" {
  default = "-"
}
