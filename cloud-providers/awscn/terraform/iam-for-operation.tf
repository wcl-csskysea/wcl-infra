variable "operation_members" {
  type = set(string)
  default = [
    "tracy",
  ]
  description = "Operation team members"
}

##########################################
# IAM
##########################################
resource "aws_iam_user" "operations" {
  for_each = var.operation_members
  name     = each.key
}

resource "aws_iam_user_group_membership" "operations" {
  for_each = var.operation_members
  user     = aws_iam_user.operations[each.key].name

  groups = [
    aws_iam_group.operations.name,
  ]
}

resource "aws_iam_group" "operations" {
  name = "operations"
  path = "/teams/"
}


resource "aws_iam_group_policy_attachment" "operations_group_billing_attach" {
  group      = aws_iam_group.operations.name
  policy_arn = "arn:aws-cn:iam::aws:policy/job-function/Billing"
}

