variable "prefix" {}

variable "public" {
  default = true
}

variable "private" {
  default = true
}

variable "index_document" {
  default = "index.html"
}

data "template_file" "private_bucket_name" {
  template = "${format("%s_private", var.prefix)}"
}

data "template_file" "public_bucket_name" {
  template = "${format("%s_public", var.prefix)}"
}

data "template_file" "public_bucket_policy" {
  template = "${file("${path.module}/templates/public_bucket_policy.json")}"

  vars {
    bucket_name = "${data.template_file.public_bucket_name.rendered}"
  }
}
