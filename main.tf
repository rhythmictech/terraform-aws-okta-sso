
resource "aws_iam_saml_provider" "saml_provider" {
  count                  = "${length(keys(var.saml_providers))}"
  name                   = "${element(keys(var.saml_providers), count.index)}"
  saml_metadata_document = "${element(values(var.saml_providers), count.index)}"
}

data "aws_iam_policy_document" "okta_sso_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
        "sts:AssumeRoleWithSAML",
        "iam:ListAccountAliases",
        "iam:ListRoles"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_group" "okta_sso_group" {
  name = "okta-sso"
  path = "/"
}

resource "aws_iam_group_policy" "okta_sso_policy" {
  name  = "okta_sso_policy"
  group = "${aws_iam_group.okta_sso_group.id}"

  policy = "${data.aws_iam_policy_document.okta_sso_policy_doc.json}"
}

resource "aws_iam_user" "okta_sso_user" {
  name = "okta-sso"
  path = "/"
}

resource "aws_iam_user_group_membership" "okta_sso_group_membership" {
  user = "${aws_iam_user.okta_sso_user.name}"

  groups = [
    "${aws_iam_group.okta_sso_group.name}"
  ]
}

resource "aws_iam_access_key" "okta_sso_user_key" {
  user = aws_iam_user.okta_sso_user.name
}

resource "aws_secretsmanager_secret" "secret_key" {
  name_prefix = "okta_sso_user"


}

resource "aws_secretsmanager_secret_version" "secret_key_value" {
  secret_id     = aws_secretsmanager_secret.secret_key.id
  secret_string = aws_iam_access_key.okta_sso_user_key.secret
}