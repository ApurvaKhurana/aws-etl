data "aws_subnet_ids" "subnets" {
  vpc_id = var.vpc_id
}

data "archive_file" "bronze_to_silver_function" {
  type        = "zip"
  source_file = "./scripts/bronze-to-silver-lambda.py"
  output_path = "./dist/lambda.zip"
}

resource "aws_lambda_function" "bronze_to_silver_function" {
  filename         = "./dist/lambda.zip"
  source_code_hash = data.archive_file.bronze_to_silver_function.output_base64sha256
  function_name    = "sltel-${var.env}-bronze-to-silver"
  description      = "moves files from bronze to silver bucket."
  handler          = "bronze-to-silver-lambda.lambda_handler"
  runtime          = "python3.6"
  timeout          = "600"

  role = var.s3_lambda_role_arn

  publish = true

  vpc_config {
    subnet_ids         = ["${data.aws_subnet_ids.subnets.ids}"]
    security_group_ids = ["${aws_security_group.sg_for_lambda.id}"]
  }

  environment {
    variables = {
      ENV                = var.env
      SOURCE_BUCKET      = var.bronze_bucket_name
      SOURCE_PATH        = var.bronze_bucket_path
      SOURCE_ROLE_ARN_S3 = var.bronze_s3_role_arn
      DEST_BUCKET        = var.silver_bucket_name
      DEST_PATH          = var.silver_bucket_path
      DEST_ROLE_ARN_S3   = var.silver_s3_role_arn
      KMS_KEY_ID         = var.silver_kms_key_id
      TZ                 = "Australia/Melbourne"
      http_proxy         = "xxx"
      https_proxy        = "xxx"
      no_proxy           = "yyy"
    }
  }

  # tagging
  tags {
    CostCentre    = "xxx"
    ApplicationID = "yyy"
    AppCategory   = "zzz"
    Name          = "sletl-${var.env}-bronze-to-silver-lambda"
  }
}

resource "aws_lambda_alias" "bronze_to_silver_function" {
  name             = "sletl-${var.env}-bronze-to-silver"
  description      = "Alias for function"
  function_name    = aws_lambda_function.bronze_to_silver_function.arn
  function_version = "$LATEST"
}

resource "aws_cloudwatch_event_rule" "bronze_to_silver_rule" {
  name                = "sletl-${var.env}-bronze-to-silver-rule"
  description         = "Fires every day at 1am AEST"
  schedule_expression = "cron(0 15 * * ? *)"
  is_enabled          = var.bronze_to_silver_is_enabled
}

resource "aws_cloudwatch_event_target" "bronze-to-silver-rule-attachment" {
  rule      = aws_cloudwatch_event_rule.bronze_to_silver_rule.name
  target_id = "bronze_to_silver_function"
  arn       = aws_lambda_function.bronze_to_silver_function.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_bronze_to_silver_lambda_function" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.bronze_to_silver_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.bronze_to_silver_rule.arn
}