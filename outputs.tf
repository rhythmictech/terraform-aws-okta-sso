output "iam_access_key_okta_user" {
  description = "ID of IAM access key for new Okta user"
  value       = var.create_okta_iam_user ? aws_iam_access_key.this[0].id : null
}

output "iam_user_okta" {
  description = "User name for new Okta user"
  value       = var.create_okta_iam_user ? aws_iam_user.this[0].name : null
}

output "secretsmanager_secret_okta_user_secret_key" {
  description = "ARN of Secrets Manager secret containing new Okta user's IAM access key"
  value       = var.create_okta_iam_user ? aws_secretsmanager_secret.this[0].id : null
}
