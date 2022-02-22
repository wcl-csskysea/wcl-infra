#################
# vars
###################
variable "terraforms" {
  type = set(string)
  default = [
    "terraform-grafana",
  ]
  description = "user to use terraform S3/DynamoDB"
}

variable "terraform-state-bucket" {
  type    = string
  default = "terraform-infrastructure-state"
}

variable "terraform-state-dynamodb-table" {
  type    = string
  default = "terraform-infrastructure-state-lock"
}

##########################################
# IAM
##########################################
resource "aws_iam_user" "terraform" {
  for_each = var.terraforms
  name     = each.key
}

resource "aws_iam_user_group_membership" "terraform" {
  for_each = var.terraforms
  user     = aws_iam_user.terraform[each.key].name

  groups = [
    aws_iam_group.terraform.name,
  ]
}

resource "aws_iam_group" "terraform" {
  name = "terraform"
  path = "/tools/"
}

resource "aws_iam_policy" "access_tfstate_dynamodb" {
  name = "access-tfstate-dynamodb-table"
  path = "/tools/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ],
        "Resource" : "arn:aws-cn:dynamodb:*:*:table/${var.terraform-state-dynamodb-table}"
      }
    ]
  })
}

resource "aws_iam_policy" "access_tfstate_s3" {
  for_each    = var.terraforms
  name        = "access-${each.key}-tfstate-in-s3"
  path        = "/tools/"
  description = "Access the tfstate files in s3 for terraform ${each.key}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : "s3:ListBucket",
        "Resource" : "arn:aws-cn:s3:::${var.terraform-state-bucket}"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource" : "arn:aws-cn:s3:::${var.terraform-state-bucket}/${each.key}/terraform.tfstate"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_terraform_s3_policy" {
  for_each   = var.terraforms
  user       = aws_iam_user.terraform[each.key].name
  policy_arn = aws_iam_policy.access_tfstate_s3[each.key].arn
}


resource "aws_iam_group_policy_attachment" "attach_terraform_dynamodb_policy" {
  group      = aws_iam_group.terraform.name
  policy_arn = aws_iam_policy.access_tfstate_dynamodb.arn
}


########################
# Access keys
########################
resource "aws_iam_access_key" "terraform" {
  for_each = var.terraforms
  user     = aws_iam_user.terraform[each.key].name
}
## uncomment this if you need to get the secret key
#resource "local_file" "teleport_iam_user_access_secret" {
#  for_each = var.terraforms
#  content  = aws_iam_access_key.terraform[each.key].secret
#  filename = ".aws_secret_for_${each.key}"
#}
