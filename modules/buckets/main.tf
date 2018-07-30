resource "aws_s3_bucket" "public_bucket" {
  bucket = "${data.template_file.bucket_name.rendered}"
  acl    = "public-read"
  policy = "${data.template_file.bucket_policy.rendered}"
  count  = "${var.public}"

  website {
    index_document = "${var.index_document}"
  }
}

resource "aws_s3_bucket" "private_bucket" {
  bucket = "${data.template_file.private_bucket_name.rendered}"
  count  = "${var.private}"
  acl    = "private"
}
