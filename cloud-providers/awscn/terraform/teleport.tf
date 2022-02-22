output "teleport_iam_user_access_id" {
  value = aws_iam_access_key.teleport.id
}

# uncomment this if you need to get the secret key
#resource "local_file" "teleport_iam_user_access_secret" {
#  content  = aws_iam_access_key.teleport.secret
#  filename = ".aws_secret"
#}


##########################################
# Dynamodb
##########################################
resource "aws_dynamodb_table" "teleport_auth" {
  name           = "teleport-auth"
  hash_key       = "HashKey"
  range_key      = "FullPath"
  read_capacity  = 10
  write_capacity = 10
  server_side_encryption {
    enabled = true
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
    ]
  }

  attribute {
    name = "HashKey"
    type = "S"
  }

  attribute {
    name = "FullPath"
    type = "S"
  }

  stream_enabled   = "true"
  stream_view_type = "NEW_IMAGE"

  ttl {
    attribute_name = "Expires"
    enabled        = true
  }

  tags = {
    Name        = "Teleport Auth Dynamodb"
    Environment = "production"
  }
}

// DynamoDB table for storing cluster events
resource "aws_dynamodb_table" "teleport_events" {
  name           = "teleport-events"
  hash_key       = "SessionID"
  range_key      = "EventIndex"
  read_capacity  = 10
  write_capacity = 10

  server_side_encryption {
    enabled = true
  }

  global_secondary_index {
    name            = "timesearchV2"
    hash_key        = "CreatedAtDate"
    range_key       = "CreatedAt"
    write_capacity  = 10
    read_capacity   = 10
    projection_type = "ALL"
  }

  lifecycle {
    ignore_changes = all
  }

  attribute {
    name = "SessionID"
    type = "S"
  }

  attribute {
    name = "EventIndex"
    type = "N"
  }

  attribute {
    name = "CreatedAtDate"
    type = "S"
  }

  attribute {
    name = "CreatedAt"
    type = "N"
  }

  ttl {
    attribute_name = "Expires"
    enabled        = true
  }

  tags = {
    Name        = "Teleport Events Dynamodb"
    Environment = "production"
  }
}

##########################################
# S3
##########################################
resource "aws_s3_bucket" "teleport_sessions" {
  bucket = "teleport-sessions"

  lifecycle {
    prevent_destroy = true
  }

}



##########################################
# IAM
##########################################
resource "aws_iam_user" "teleport" {
  name = "teleport"
}

resource "aws_iam_access_key" "teleport" {
  user = aws_iam_user.teleport.name
}


##########################################
# IAM Policy
##########################################
resource "aws_iam_policy" "teleport_dynamodb_access" {
  name        = "teleport-dynamodb-access"
  path        = "/infrastructure/teleport/"
  description = "Allow all actions for object to ${aws_dynamodb_table.teleport_auth.id}"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Sid" : "AllAPIActionsOnTeleportAuth",
      "Effect" : "Allow",
      "Action" : "dynamodb:*",
      "Resource" : "${aws_dynamodb_table.teleport_auth.arn}"
      },
      {
        "Sid" : "AllAPIActionsOnTeleportStreams",
        "Effect" : "Allow",
        "Action" : "dynamodb:*",
        "Resource" : "${aws_dynamodb_table.teleport_auth.arn}/stream/*"
      },
      {
        "Sid" : "AllAPIActionsOnTeleportEvents",
        "Effect" : "Allow",
        "Action" : "dynamodb:*",
        "Resource" : "${aws_dynamodb_table.teleport_events.arn}"
      },
      {
        "Sid" : "AllAPIActionsOnTeleportEventsIndex",
        "Effect" : "Allow",
        "Action" : "dynamodb:*",
        "Resource" : "${aws_dynamodb_table.teleport_events.arn}/index/*"
      }
    ]
  })
}

resource "aws_iam_policy" "teleport_s3_access" {
  name        = "teleport-s3-access"
  path        = "/infrastructure/teleport/"
  description = "Allow all actions for object to ${aws_s3_bucket.teleport_sessions.bucket}"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:HeadObject"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws-cn:s3:::${aws_s3_bucket.teleport_sessions.bucket}/",
          "arn:aws-cn:s3:::${aws_s3_bucket.teleport_sessions.bucket}/*"
        ]
      }
    ]
  })
}


resource "aws_iam_user_policy_attachment" "teleport_auth_dynamondb_attach" {
  user       = aws_iam_user.teleport.name
  policy_arn = aws_iam_policy.teleport_dynamodb_access.arn
}

resource "aws_iam_user_policy_attachment" "teleport_s3_attach" {
  user       = aws_iam_user.teleport.name
  policy_arn = aws_iam_policy.teleport_s3_access.arn
}
