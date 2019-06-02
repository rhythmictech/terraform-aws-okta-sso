
locals {
  common_tags = {
    namespace = "${var.namespace}"
    owner     = "${var.owner}"
    env       = "${var.env}"
  }
}

variable "region" {
  type = "string"
}

variable "namespace" {
  type = "string"
}

variable "owner" {
  type = "string"
}

variable "env" {
  type    = "string"
  default = "global"
}

variable "saml_providers" {
  type    = "map"
}

