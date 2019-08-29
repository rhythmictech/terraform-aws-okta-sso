output "okta_sso_user_key_id" {
  value = aws_iam_access_key.okta_sso_user_key.id
}

output "okta_sso_user_key" {
  value = aws_iam_user.okta_sso_user.name
}

output "okta_sso_user_key_secret_arn" {
  value = aws_secretsmanager_secret.secret_key.id
}
