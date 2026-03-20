output "log_group_name" {
  description = "The name of the CloudWatch log group"
  value       = module.cloudwatch.log_group_name
}

output "log_group_arn" {
  description = "The ARN of the CloudWatch log group"
  value       = module.cloudwatch.log_group_arn
}

output "log_stream_name" {
  description = "The name of the CloudWatch log stream"
  value       = module.cloudwatch.log_stream_name
}

output "log_metric_filter_id" {
  description = "The name of the metric filter"
  value       = module.cloudwatch.log_metric_filter_id
}

output "metric_alarm_arn" {
  description = "The ARN of the CloudWatch metric alarm"
  value       = module.cloudwatch.metric_alarm_arn
}

output "query_definition_id" {
  description = "The unique identifier of the CloudWatch Logs Insights query definition"
  value       = module.cloudwatch.query_definition_id
}
