output "private_bucket" {
  value = "${element(concat(aws_s3_bucket.private_bucket.*.bucket, list("")), 0)}"
}

output "public_bucket" {
  value = "${element(concat(aws_s3_bucket.public_bucket.*.bucket, list("")), 0)}"
}
