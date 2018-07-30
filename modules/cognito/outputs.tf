output "idp_authenticated_role_policy_arn" {
  value = "${element(concat(aws_iam_role.idp_authenticated_role.*.arn, list("")), 0)}"
}

output "idp_unauthenticated_role_policy_arn" {
  value = "${element(concat(aws_iam_role.idp_unauthenticated_role.*.arn, list("")), 0)}"
}
