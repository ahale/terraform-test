data "template_file" "project_name" {
  template = "${format("%s_%s", var.project, var.stage)}"
}

data "template_file" "app_cognito_name" {
  template = "${format("app_%s_%s", var.project, var.stage)}"
}

data "template_file" "kibana_cognito_name" {
  template = "${format("kibana_%s_%s", var.project, var.stage)}"
}

data "template_file" "elasticsearch_domain" {
  template = "${format("%s-%s", var.project, var.stage)}"
}
