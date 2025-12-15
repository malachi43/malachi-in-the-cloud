provider "aws" {
  region = "eu-west-1"
}

# SNS Topic
resource "aws_sns_topic" "sport_notification_alerts" {
  name = "sport_notification_alerts"
}


# IAM role for lambda
resource "aws_iam_role" "lambda_role" {
  name = "sport_notification_lambda_role"

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

#IAM policy for Lambda to publish to SNS
resource "aws_iam_policy" "sns_publish_policy" {
  name        = "sns_publish_policy"
  description = "Policy to allow Lambda to publish to SNS"
  policy      = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Action": "sns:Publish",
        "Resource": "${aws_sns_topic.sport_notification_alerts.arn}"
        }
      ]
     } 
  EOF
}


#Attach IAM Policy for Lambda to publish to SNS to IAM Role
resource "aws_iam_role_policy_attachment" "attach_sns_publish" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.sns_publish_policy.arn

}


data "aws_caller_identity" "current" {}


#IAM policy to Read from Parameter Store (AWS System Manager)
resource "aws_iam_policy" "ssm_policy" {
  name        = "ssm_parameter_access"
  description = "Allow sport-notification-api.js to read SPORT DATA IO API KEY from Parameter store"
  policy      = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Action": "ssm:GetParameter",
        "Resource": "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/sport-data-io-api-key"
        }
      ]
     } 
  EOF
}

#Attach Policy to Lambda to read SPORT DATA IO API KEY from Parameter Store
resource "aws_iam_role_policy_attachment" "attach_read_param_store" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.ssm_policy.arn

}


#Create for CloudWatch - important for logging (Lambda Function)
resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging_policy"
  description = "Allow lambda to write logs"
  policy      = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
        }
      ]
    }
   EOF
}

#Attach CloudWatch Loggind Policy to IAM Role
resource "aws_iam_role_policy_attachment" "attach_logging" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

#Lambda Function
resource "aws_lambda_function" "sport_notification_lambda" {
  filename      = "sport-notification.zip"
  function_name = "sport-notifications"
  role          = aws_iam_role.lambda_role.arn
  handler       = "sport-notification-api.handler"
  runtime       = "nodejs24.x"

  environment {
    variables = {
      AWS_SNS_TOPIC_ARN = aws_sns_topic.sport_notification_alerts.arn
      AWS_SNS_REGION    = "eu-west-1"
    }
  }
}

#EventBridge Rule for Scheduling
resource "aws_cloudwatch_event_rule" "sport_notification_scheduler" {
  name                = "sport_notification_schedule"
  schedule_expression = "rate(2 hours)" #Adjust to your preference.
}

#Event Target
resource "aws_cloudwatch_event_target" "sport_notification_target" {
  rule      = aws_cloudwatch_event_rule.sport_notification_scheduler.name
  target_id = "sport_notification_lambda"
  arn       = aws_lambda_function.sport_notification_lambda.arn

}

#Grant EventBridge Permission to invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sport_notification_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sport_notification_scheduler.arn
}
