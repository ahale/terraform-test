resource "aws_elasticsearch_domain" "elasticsearch_domain" {
  domain_name           = "${var.domain_name}"
  elasticsearch_version = "${var.version}"
  count                 = "${var.build}"

  cluster_config {
    instance_type            = "${var.instance_type}"
    instance_count           = "${var.instance_count}"
    dedicated_master_enabled = "${var.dedicated_master_enabled}"
    dedicated_master_type    = "${var.master_instance_type}"
    dedicated_master_count   = "${var.dedicated_master_count}"
    zone_awareness_enabled   = "${var.zone_awareness_enabled}"
  }

  snapshot_options {
    automated_snapshot_start_hour = "${var.automated_snapshot_start_hour}"
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  ebs_options = {
    ebs_enabled = "${var.ebs_enabled}"
    volume_type = "${var.volume_type}"
    volume_size = "${var.volume_size}"
  }

  access_policies = "${data.template_file.default_elasticsearch_domain_policy.rendered}"
}

data "template_file" "default_elasticsearch_domain_policy" {
  template = "${file("${path.module}/templates/myip_elasticsearch_domain_policy.json")}"

  vars {
    admin_arn    = "${var.admin_arn}"
    readonly_arn = "${var.readonly_arn}"
    domain       = "${var.domain_name}"
    region       = "${var.region}"
  }
}

data "template_file" "admin_elasticsearch_policy" {
  template = "${file("${path.module}/templates/admin_elasticsearch_policy.json")}"

  vars {
    domain = "${var.domain_name}"
    region = "${var.region}"
  }
}

resource "aws_iam_policy" "admin_elasticsearch" {
  name   = "${data.template_file.admin_elasticsearch_policy_name.rendered}"
  path   = "/"
  policy = "${data.template_file.admin_elasticsearch_policy.rendered}"
}

data "template_file" "readonly_elasticsearch_policy" {
  template = "${file("${path.module}/templates/readonly_elasticsearch_policy.json")}"

  vars {
    domain = "${var.domain_name}"
    region = "${var.region}"
  }
}

resource "aws_iam_policy" "readonly_elasticsearch" {
  name   = "${data.template_file.readonly_elasticsearch_policy_name.rendered}"
  path   = "/"
  policy = "${data.template_file.readonly_elasticsearch_policy.rendered}"
}
