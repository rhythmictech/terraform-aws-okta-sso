
resource "aws_iam_saml_provider" "this" {
  for_each = toset(keys(var.saml_providers))

  name                   = each.value
  saml_metadata_document = var.saml_providers[each.value]
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
  count = var.create_okta_iam_user ? 1 : 0

  name = var.iam_user_name
  path = "/"
  tags = var.tags
}

resource "aws_iam_user_group_membership" "this" {
  count = var.create_okta_iam_user ? 1 : 0

  user = aws_iam_user.this[0].name
  groups = [
    aws_iam_group.this.name
  ]
}

resource "aws_iam_access_key" "this" {
  count = var.create_okta_iam_user ? 1 : 0

  user = aws_iam_user.this[0].name
}

resource "aws_secretsmanager_secret" "this" {
  count = var.create_okta_iam_user ? 1 : 0

  name_prefix = "terraform-okta-sso"
  description = "Okta SSO user access key"
  kms_key_id  = var.kms_key_id
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  count = var.create_okta_iam_user ? 1 : 0

  secret_id     = aws_secretsmanager_secret.this[0].id
  secret_string = aws_iam_access_key.this[0].secret
}

moved {
  from = aws_iam_user.this
  to   = aws_iam_user.this[0]
}

moved {
  from = aws_iam_user_group_membership.this
  to   = aws_iam_user_group_membership.this[0]
}

moved {
  from = aws_iam_access_key.this
  to   = aws_iam_access_key.this[0]
}

moved {
  from = aws_secretsmanager_secret.this
  to   = aws_secretsmanager_secret.this[0]
}

moved {
  from = aws_secretsmanager_secret_version.this
  to   = aws_secretsmanager_secret_version.this[0]
}
