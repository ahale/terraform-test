variable "domain_name" {
  description = "The name of elasticsearch domain to create"
}

variable "admin_arn" {}

variable "readonly_arn" {}

variable "region" {
  default = "eu-west-1"
}

variable "version" {
  default = "6.2"
}

variable "build" {
  default = true
}

variable "instance_type" {
  default = "r3.large.elasticsearch"
}

variable "dedicated_master_enabled" {
  default = false
}

variable "master_instance_type" {
  default = "t2.small.elasticsearch"
}

variable "instance_count" {
  default = 1
}

variable "dedicated_master_count" {
  default = 0
}

variable "zone_awareness_enabled" {
  default = false
}

variable "automated_snapshot_start_hour" {
  default = 23
}

variable "ebs_enabled" {
  default = true
}

variable "volume_type" {
  default = "gp2"
}

variable "volume_size" {
  default = 10
}

variable "iops" {
  default = false
}

variable "encrypted_at_rest" {}

data "template_file" "admin_elasticsearch_policy_name" {
  template = "${format("admin_elasticsearch_policy_%s", var.domain_name)}"
}

data "template_file" "readonly_elasticsearch_policy_name" {
  template = "${format("readonly_elasticsearch_policy_%s", var.domain_name)}"
}
