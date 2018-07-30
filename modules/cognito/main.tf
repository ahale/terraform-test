resource "aws_cognito_user_pool" "userpool" {
  name                     = "${data.template_file.userpool_name.rendered}"
  mfa_configuration        = "${var.userpool_mfa_configuration}"
  password_policy          = "${var.userpool_password_policy}"
  auto_verified_attributes = ["email"]

  admin_create_user_config = {
    allow_admin_create_user_only = "${var.userpool_allow_admin_create_user_only}"
  }
}

# resource "aws_lambda_function" "userpool_lambda" {
#   function_name = "${data.template_file.userpool_lambda_name.rendered}"
#   runtime       = "python3.6"
#   role          = "${aws_iam_role.lambda_exec_role.arn}"
#   handler       = "lambda.lambda_handler"
# }

resource "aws_cognito_user_pool_client" "userpool_appclient" {
  user_pool_id                 = "${aws_cognito_user_pool.userpool.id}"
  name                         = "${data.template_file.appclient_name.rendered}"
  generate_secret              = "${var.appclient_generate_secret}"
  supported_identity_providers = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "userpool_domain" {
  user_pool_id = "${aws_cognito_user_pool.userpool.id}"
  domain       = "${replace(data.template_file.appclient_domain_name.rendered, var.search, var.replace)}"
}

resource "aws_cognito_identity_pool" "identitypool" {
  identity_pool_name               = "${data.template_file.idp_name.rendered}"
  allow_unauthenticated_identities = "${var.allow_unauthenticated_identities}"

  cognito_identity_providers {
    client_id               = "${aws_cognito_user_pool_client.userpool_appclient.id}"
    provider_name           = "${data.template_file.idp_provider_name.rendered}"
    server_side_token_check = false
  }
}

data "template_file" "idp_provider_name" {
  template = "${format("cognito-idp.%s.amazonaws.com/%s", var.region, aws_cognito_user_pool.userpool.id)}"
}

resource "aws_cognito_identity_pool_roles_attachment" "idp_roles_attachment" {
  identity_pool_id = "${aws_cognito_identity_pool.identitypool.id}"

  roles {
    "authenticated"   = "${aws_iam_role.idp_authenticated_role.arn}"
    "unauthenticated" = "${aws_iam_role.idp_unauthenticated_role.arn}"
  }
}

resource "aws_iam_role" "idp_authenticated_role" {
  name               = "${data.template_file.idp_authenticated_role_name.rendered}"
  assume_role_policy = "${data.template_file.idp_authenticated_role_policy.rendered}"
}

resource "aws_iam_role" "idp_unauthenticated_role" {
  name               = "${data.template_file.idp_unauthenticated_role_name.rendered}"
  assume_role_policy = "${data.template_file.idp_unauthenticated_role_policy.rendered}"
}

data "template_file" "idp_authenticated_role_policy" {
  template = "${file("${path.module}/templates/idp_authenticated_role_policy.json")}"

  vars {
    idp_id = "${aws_cognito_identity_pool.identitypool.id}"
  }
}

resource "aws_iam_role_policy" "idp_authenticated_role_policy_attachment" {
  name   = "aaa"
  role   = "${aws_iam_role.idp_authenticated_role.id}"
  policy = "${data.template_file.idp_authenticated_role_policy_attachment_policy.rendered}"
}

resource "aws_iam_role_policy" "idp_unauthenticated_role_policy_attachment" {
  name   = "aaa"
  role   = "${aws_iam_role.idp_unauthenticated_role.id}"
  policy = "${data.template_file.idp_unauthenticated_role_policy_attachment_policy.rendered}"
}

data "template_file" "idp_authenticated_role_policy_attachment_policy" {
  template = "${file("${path.module}/templates/idp_unauthenticated_role_policy_attachment.json")}"
}

data "template_file" "idp_unauthenticated_role_policy_attachment_policy" {
  template = "${file("${path.module}/templates/idp_unauthenticated_role_policy_attachment.json")}"
}

data "template_file" "idp_unauthenticated_role_policy" {
  template = "${file("${path.module}/templates/idp_unauthenticated_role_policy.json")}"

  vars {
    idp_id = "${aws_cognito_identity_pool.identitypool.id}"
  }
}
