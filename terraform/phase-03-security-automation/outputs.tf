output "sns_topic_arn" {
  description = "Security alerts SNS topic ARN"
  value       = aws_sns_topic.security_alerts.arn
}

output "lambda_function_arn" {
  description = "Incident response Lambda ARN"
  value       = aws_lambda_function.incident_response.arn
}

output "eventbridge_rule_arn" {
  description = "EventBridge rule ARN"
  value       = aws_cloudwatch_event_rule.ec2_state_change.arn
}

output "inspector_enabled" {
  description = "Inspector2 enabled for EC2 scanning"
  value       = true
}