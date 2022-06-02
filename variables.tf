variable "iam_group_name" {
  default     = "okta-sso"
  description = "Name of the IAM group Okta IAM policies will be attached to"
  type        = string
}

variable "iam_user_name" {
  default     = "okta-sso"
  description = "Username for the Okta service account"
  type        = string
}

variable "kms_key_id" {
  default = ""
  description = "kms key id to encrypt Okta Secret"
  type = string
 }

variable "saml_providers" {
  description = "A map of SAML provider names and metadata"
  type        = map(string)
}

variable "tags" {
  default     = {}
  description = "Tags to apply to supported resources"
  type        = map(string)
}
