################################################################################
# Log Group
################################################################################

output "log_group_name" {
  description = "The name of the CloudWatch log group"
  value       = module.log_group.cloudwatch_log_group_name
}

output "log_group_arn" {
  description = "The ARN of the CloudWatch log group"
  value       = module.log_group.cloudwatch_log_group_arn
}

output "log_stream_name" {
  description = "The name of the CloudWatch log stream"
  value       = module.log_stream.cloudwatch_log_stream_name
}

################################################################################
# Log Metric Filter
################################################################################

output "log_metric_filter_id" {
  description = "The ID of the metric filter"
  value       = module.log_metric_filter.cloudwatch_log_metric_filter_id
}

################################################################################
# Metric Alarm
################################################################################

output "metric_alarm_id" {
  description = "The ID of the CloudWatch metric alarm"
  value       = module.metric_alarm.cloudwatch_metric_alarm_id
}

output "metric_alarm_arn" {
  description = "The ARN of the CloudWatch metric alarm"
  value       = module.metric_alarm.cloudwatch_metric_alarm_arn
}

################################################################################
# Composite Alarm
################################################################################

output "composite_alarm_id" {
  description = "The ID of the CloudWatch composite alarm"
  value       = module.composite_alarm.cloudwatch_composite_alarm_id
}

output "composite_alarm_arn" {
  description = "The ARN of the CloudWatch composite alarm"
  value       = module.composite_alarm.cloudwatch_composite_alarm_arn
}

################################################################################
# Log Subscription Filter
################################################################################

output "log_subscription_filter_name" {
  description = "The name of the subscription filter"
  value       = module.log_subscription_filter.cloudwatch_log_subscription_filter_name
}

################################################################################
# Log Data Protection Policy
################################################################################

output "log_data_protection_policy_log_group_name" {
  description = "The log group name for log data protection policy"
  value       = module.log_data_protection_policy.log_group_name
}

################################################################################
# Log Account Policy
################################################################################

output "log_account_policy_name" {
  description = "The name of the log account policy"
  value       = module.log_account_policy.log_account_policy_name
}

################################################################################
# Log Anomaly Detector
################################################################################

output "log_anomaly_detector_arn" {
  description = "The ARN of the log anomaly detector"
  value       = module.log_anomaly_detector.arn
}

################################################################################
# Metric Stream
################################################################################

output "metric_stream_arn" {
  description = "The ARN of the CloudWatch metric stream"
  value       = module.metric_stream.cloudwatch_metric_stream
}

output "metric_stream_creation_date" {
  description = "Date and time in RFC3339 format that the metric stream was created"
  value       = module.metric_stream.cloudwatch_metric_stream_creation_date
}

output "metric_stream_last_update_date" {
  description = "Date and time in RFC3339 format that the metric stream was last updated"
  value       = module.metric_stream.cloudwatch_metric_stream_last_update_date
}

output "metric_stream_state" {
  description = "State of the metric stream (running or stopped)"
  value       = module.metric_stream.cloudwatch_metric_stream_state
}

################################################################################
# Query Definition
################################################################################

output "query_definition_id" {
  description = "The unique identifier of the CloudWatch Logs Insights query definition"
  value       = module.query_definition.cloudwatch_query_definition_id
}
