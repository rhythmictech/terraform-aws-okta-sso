# terraform-aws-okta-sso

[![](https://github.com/rhythmictech/terraform-aws-okta-sso/workflows/check/badge.svg)](https://github.com/rhythmictech/terraform-aws-okta-sso/actions)

Configures the AWS side of an AWS/Okta SSO integration. Per the [Okta how-to guide](https://saml-doc.okta.com/SAML_Docs/How-to-Configure-SAML-2.0-for-Amazon-Web-Service), this will create a SAML provider and a user with minimal IAM access to enable Okta to sync AWS roles.

Example:

```
data "local_file" "metadata" {
  filename = "metadata.xml"
}

module "okta-sso" {
  source    = "git::ssh://git@github.com/rhythmictech/terraform-okta-sso"
  saml_providers = {
    "someco" = data.local_file.metadata.content
  }
}
```

IAM roles are mapped to Okta groups, and users can assume those roles via Okta SAML integration. For each such IAM role, the trust relationship needs to be modified to permit Okta access. The following `aws_iam_policy_document` provides a sample policy that can be used as the assume policy for a role:

```
data "aws_iam_policy_document" "this" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithSAML"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${local.account_id}:saml-provider/someco"]
    }

    condition {
      test     = "StringEquals"
      variable = "SAML:aud"
      values   = ["https://signin.aws.amazon.com/saml"]
    }
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| iam\_group\_name | Name of the IAM group Okta IAM policies will be attached to | string | `"okta-sso"` | no |
| iam\_user\_name | Username for the Okta service account | string | `"okta-sso"` | no |
| saml\_providers | A map of SAML provider names and metadata | map(string) | n/a | yes |
| tags | Tags to apply to supported resources | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| iam\_access\_key\_okta\_user |  |
| iam\_user\_okta |  |
| secretsmanager\_secret\_okta\_user\_secret\_key |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
