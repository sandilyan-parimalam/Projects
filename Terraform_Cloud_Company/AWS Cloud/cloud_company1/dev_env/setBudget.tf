resource "aws_budgets_budget" "devops_budget" {
  name              = var.budget_name
  budget_type       = var.budget_type
  limit_amount      = var.budget_limit_amount
  limit_unit        = var.budget_limit_unit
  time_unit         = var.budget_time_unit
  time_period_start = var.budget_time_period_start
}
