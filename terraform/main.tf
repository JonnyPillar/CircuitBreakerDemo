terraform {
  required_version = "1.0.8"


  required_providers {
    aws = "~> 3.64"
  }
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_s3_bucket" "artefact_bucket" {
  bucket = "circuit-breaker-demo-artefacts"
}

data "aws_s3_bucket_object" "event_generator_artifact_bucket_object" {
  bucket = "circuit-breaker-demo-artefacts"
  key    = "EventGenertator.zip"
}

data "aws_s3_bucket_object" "event_processor_artifact_bucket_object" {
  bucket = "circuit-breaker-demo-artefacts"
  key    = "EventProcessor.zip"
}

data "aws_s3_bucket_object" "evil_api_artifact_bucket_object" {
  bucket = "circuit-breaker-demo-artefacts"
  key    = "EvilCorpAPI.zip"
}

resource "aws_lambda_function" "event_generator" {
  function_name = "event-generator"
  description   = "Lambda that generates events"

  s3_bucket         = data.aws_s3_bucket.artefact_bucket.bucket
  s3_key            = "EventGenertator.zip"
  s3_object_version = data.aws_s3_bucket_object.event_generator_artifact_bucket_object.version_id
  role              = aws_iam_role.event_generator_role.arn

  handler = "lambda"
  runtime = "go1.x"
  timeout = 30

  environment {
    variables = {
      SQS_QUEUE_URL = aws_sqs_queue.queue.url
    }
  }
}

resource "aws_lambda_function" "event_processor" {
  function_name = "event-processor"
  description   = "Lambda that generates events"

  s3_bucket         = data.aws_s3_bucket.artefact_bucket.bucket
  s3_key            = "EventProcessor.zip"
  s3_object_version = data.aws_s3_bucket_object.event_processor_artifact_bucket_object.version_id
  role              = aws_iam_role.event_processor_role.arn

  handler = "lambda"
  runtime = "go1.x"
  timeout = 30

  environment {
    variables = {
      API_URL = "https://6shswyxy77.execute-api.eu-west-1.amazonaws.com/api/api/poll"
    }
  }
}

resource "aws_lambda_function" "evil_api" {
  function_name = "evil-api"
  description   = "Lambda have an evil API"

  s3_bucket         = data.aws_s3_bucket.artefact_bucket.bucket
  s3_key            = "EvilCorpAPI.zip"
  s3_object_version = data.aws_s3_bucket_object.evil_api_artifact_bucket_object.version_id
  role              = aws_iam_role.evil_api_role.arn

  handler = "lambda"
  runtime = "go1.x"
  timeout = 30
}

resource "aws_sqs_queue" "queue" {
  name = "evil-corp-events"
}
