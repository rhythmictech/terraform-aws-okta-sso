output "iam_access_key_okta_user" {
description = "ID of IAM access key for new Okta user"
  value = aws_iam_access_key.this.id
}

output "iam_user_okta" {
description = "User name for new Okta user"
  value = aws_iam_user.this.name
}

output "secretsmanager_secret_okta_user_secret_key" {
description = "ARN of Secrets Manager secret containing new Okta user's IAM access key"
  value = aws_secretsmanager_secret.this.id
}
