output "iam_access_key_okta_user" {
  value = aws_iam_access_key.this.id
}

output "iam_user_okta" {
  value = aws_iam_user.this.name
}

output "secretsmanager_secret_okta_user_secret_key" {
  value = aws_secretsmanager_secret.this.id
}
