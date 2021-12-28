
resource "aws_iam_saml_provider" "this" {
  for_each               = var.saml_providers
  name                   = each.key
  saml_metadata_document = each.value
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = [
      "iam:ListAccountAliases",
      "iam:ListRoles"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_group" "this" {
  name = var.iam_group_name
  path = "/"
}

resource "aws_iam_group_policy" "this" {
  name_prefix = "terraform-okta-sso"
  group       = aws_iam_group.this.id
  policy      = data.aws_iam_policy_document.this.json
}

resource "aws_iam_user" "this" {
  name = var.iam_user_name
  path = "/"
  tags = var.tags
}

resource "aws_iam_user_group_membership" "this" {
  user = aws_iam_user.this.name
  groups = [
    aws_iam_group.this.name
  ]
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

resource "aws_secretsmanager_secret" "this" {
  name_prefix = "terraform-okta-sso"
  description = "Okta SSO user access key"
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = aws_iam_access_key.this.secret
}
