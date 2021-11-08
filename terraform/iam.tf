
resource "aws_iam_role" "event_generator_role" {
  name = "event_generator_role"

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
  name = "event_processor_role"

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
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_role" "evil_api_role" {
  name = "evil_api_role"

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


resource "aws_iam_role_policy" "evil_api_role_policy" {
  name = "evil_api_role_policy"
  role = aws_iam_role.evil_api_role.id

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
    }
  ],
  "Version": "2012-10-17"
}
EOF
}
