
resource "aws_iam_role" "event_generator_role" {
  name = "mind_hub_api_graphql_api_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "event_generator_role_policy" {
  name = "event_generator_role_policy"
  role = aws_iam_role.event_generator_role.id

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Action": [
        "sqs:SendMessage"
      ],
      "Resource": "${aws_sqs_queue.queue.arn}"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_role" "event_processor_role" {
  name = "mind_hub_api_graphql_api_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "event_processor_role_policy" {
  name = "event_processor_role_policy"
  role = aws_iam_role.event_processor_role.id

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Action": [
        "sqs:GetQueueUrl",
        "sqs:GetQueueAttributes",
        "sqs:PurgeQueue",
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:ListDeadLetterSourceQueues",
        "sqs:ChangeMessageVisibility"
      ],
      "Resource": "${aws_sqs_queue.queue.arn}"
    },
  ],
  "Version": "2012-10-17"
}
EOF
}
