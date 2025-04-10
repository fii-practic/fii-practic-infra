resource "aws_budgets_budget" "budget_monthly" {
  name         = "budget-monthly"
  budget_type  = "COST"
  limit_amount = "50"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 75
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = ["i.constantinescu@levi9.com", "iustin.achitenei@levi9.com"]
  }
}

# resource "aws_budgets_budget" "budget_monthly_ec2" {
#   name              = "budget-monthly-ec2-services"
#   budget_type       = "COST"
#   limit_amount      = "10"
#   limit_unit        = "USD"
#   time_unit         = "MONTHLY"

#   cost_filter {
#     name = "Service"
#     values = [
#       "Amazon Elastic Compute Cloud - Compute",
#     ]
#   }

#   notification {
#     comparison_operator        = "GREATER_THAN"
#     threshold                  = 75
#     threshold_type             = "PERCENTAGE"
#     notification_type          = "FORECASTED"
#     subscriber_email_addresses = ["i.constantinescu@levi9.com","iustin.achitenei@levi9.com"]
#   }
# }