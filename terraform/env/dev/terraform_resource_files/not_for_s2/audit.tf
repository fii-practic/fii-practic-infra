module "cloud_trail" {
  source     = "../../modules/audit_trail"
  account_id = var.account_ids["dev"]
  account    = var.account
}