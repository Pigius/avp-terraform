terraform {
  required_providers {
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 0.1.0"
    }
  }
}

provider "awscc" {
  region = var.aws_region
}

resource "awscc_verifiedpermissions_policy_store" "policy_store" {
  validation_settings = { mode = "STRICT" }
  schema              = { cedar_json = file("${path.module}/schema.json") }

}

resource "awscc_verifiedpermissions_policy" "allow_policy" {
  policy_store_id = awscc_verifiedpermissions_policy_store.policy_store.id
  definition = {
    static = {
      statement   = file("${path.module}/allow_policy.cedar")
      description = "Allow all users to view all documents"
    }
  }
}

resource "awscc_verifiedpermissions_policy" "forbid_policy" {
  policy_store_id = awscc_verifiedpermissions_policy_store.policy_store.id
  definition = {
    static = {
      statement   = file("${path.module}/deny_policy.cedar")
      description = "Forbid user X from viewing any documents"
    }
  }
}

