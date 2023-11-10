resource "aws_budgets_budget" "devops_budget" {
  name              = "devops_budget"
  budget_type       = "COST"
  limit_amount      = "10.0"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = "2023-11-09_00:01"

}