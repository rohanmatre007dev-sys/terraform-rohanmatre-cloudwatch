provider "aws" {
  region = "us-east-1"
}

################################################################################
# Advanced: Full CloudWatch stack
# Demonstrates all 11 sub-modules in a production-grade configuration
################################################################################

module "cloudwatch" {
  source = "../../"

  ############################################################################
  # Log Group — encrypted, long retention
  ############################################################################

  create_log_group            = true
  log_group_name              = "/app/advanced-service"
  log_group_retention_in_days = 90
  log_group_kms_key_id        = "arn:aws:kms:us-east-1:012345678901:key/mrk-xxxxxxxxxxxxxxxx"
  log_group_skip_destroy      = true
  log_group_class             = "STANDARD"

  ############################################################################
  # Log Stream
  ############################################################################

  create_log_stream = true
  log_stream_name   = "application"

  ############################################################################
  # Log Metric Filter — ERROR count with dimension
  ############################################################################

  create_log_metric_filter            = true
  metric_filter_name                  = "error-count"
  metric_filter_pattern               = "[timestamp, requestId, level=\"ERROR\", ...]"
  metric_transformation_namespace     = "AdvancedService"
  metric_transformation_name          = "ErrorCount"
  metric_transformation_value         = "1"
  metric_transformation_unit          = "Count"
  metric_transformation_default_value = "0"
  metric_transformation_dimensions = {
    ServiceName = "advanced-service"
  }

  ############################################################################
  # Metric Alarm — error threshold
  ############################################################################

  create_metric_alarm       = true
  alarm_name                = "advanced-service-errors"
  alarm_description         = "ErrorCount >= 10 in 60s triggers PagerDuty"
  alarm_comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_evaluation_periods  = 2
  alarm_datapoints_to_alarm = 2
  alarm_threshold           = 10
  alarm_period              = 60
  alarm_namespace           = "AdvancedService"
  alarm_metric_name         = "ErrorCount"
  alarm_statistic           = "Sum"
  alarm_treat_missing_data  = "notBreaching"
  alarm_actions             = ["arn:aws:sns:us-east-1:012345678901:pagerduty-critical"]
  alarm_ok_actions          = ["arn:aws:sns:us-east-1:012345678901:pagerduty-resolve"]
  alarm_dimensions = {
    ServiceName = "advanced-service"
  }

  ############################################################################
  # Composite Alarm — combines error alarm + latency alarm
  ############################################################################

  create_composite_alarm      = true
  composite_alarm_name        = "advanced-service-health"
  composite_alarm_description = "Service health composite: fires when errors AND latency are both alarming"
  composite_alarm_rule        = "ALARM(\"advanced-service-errors\") AND ALARM(\"advanced-service-latency\")"
  composite_alarm_actions     = ["arn:aws:sns:us-east-1:012345678901:pagerduty-critical"]
  composite_alarm_ok_actions  = ["arn:aws:sns:us-east-1:012345678901:pagerduty-resolve"]
  composite_alarm_actions_suppressor = {
    alarm            = "maintenance-window-suppressor"
    extension_period = 30
    wait_period      = 10
  }

  ############################################################################
  # Log Subscription Filter — forward all logs to Firehose for SIEM
  ############################################################################

  create_log_subscription_filter      = true
  subscription_filter_name            = "forward-to-firehose"
  subscription_filter_destination_arn = "arn:aws:firehose:us-east-1:012345678901:deliverystream/siem-logs"
  subscription_filter_pattern         = ""
  subscription_filter_role_arn        = "arn:aws:iam::012345678901:role/cw-logs-to-firehose"
  subscription_filter_distribution    = "ByLogStream"

  ############################################################################
  # Log Data Protection Policy — redact PII from log group
  ############################################################################

  create_log_data_protection_policy = true
  log_data_protection_policy_name   = "redact-pii"
  data_protection_data_identifiers = [
    "arn:aws:dataprotection::aws:data-identifier/EmailAddress",
    "arn:aws:dataprotection::aws:data-identifier/IpAddress",
  ]
  data_protection_findings_destination_cloudwatch_log_group = "/security/pii-findings"

  ############################################################################
  # Log Account Policy — account-wide data protection
  ############################################################################

  create_log_account_policy                 = true
  log_account_policy_name                   = "account-pii-protection"
  log_account_policy_type                   = "DATA_PROTECTION_POLICY"
  log_account_policy_create_data_protection = true
  log_account_data_protection_policy_name   = "redact-account-pii"
  log_account_data_identifiers = [
    "arn:aws:dataprotection::aws:data-identifier/EmailAddress",
    "arn:aws:dataprotection::aws:data-identifier/CreditCardNumber",
  ]
  log_account_findings_destination_cloudwatch_log_group = "/security/account-pii-findings"

  ############################################################################
  # Log Anomaly Detector — ML-based anomaly detection
  ############################################################################

  create_log_anomaly_detector           = true
  anomaly_detector_name                 = "advanced-service-anomaly"
  anomaly_detector_log_group_arns       = ["/app/advanced-service"] # resolved after apply; use ARN directly in real usage
  anomaly_detector_evaluation_frequency = "FIVE_MIN"
  anomaly_detector_visibility_time      = 14
  anomaly_detector_enabled              = true
  anomaly_detector_filter_pattern       = "%ERROR%"
  anomaly_detector_kms_key_id           = "arn:aws:kms:us-east-1:012345678901:key/mrk-xxxxxxxxxxxxxxxx"

  ############################################################################
  # Metric Stream — stream EC2 + Lambda metrics to Firehose
  ############################################################################

  create_metric_stream        = true
  metric_stream_name          = "advanced-metrics"
  metric_stream_firehose_arn  = "arn:aws:firehose:us-east-1:012345678901:deliverystream/metric-stream"
  metric_stream_output_format = "opentelemetry0.7"
  metric_stream_role_arn      = "arn:aws:iam::012345678901:role/metric-stream-role"
  metric_stream_include_filter = {
    ec2 = {
      namespace    = "AWS/EC2"
      metric_names = ["CPUUtilization", "NetworkIn", "NetworkOut"]
    }
    lambda = {
      namespace    = "AWS/Lambda"
      metric_names = ["Duration", "Errors", "Throttles", "ConcurrentExecutions"]
    }
  }
  metric_stream_statistics_configuration = [
    {
      additional_statistics = ["p99", "p95"]
      include_metric = [
        { namespace = "AWS/Lambda", metric_name = "Duration" },
      ]
    }
  ]

  ############################################################################
  # Query Definition — saved Insights queries
  ############################################################################

  create_query_definition          = true
  query_definition_name            = "advanced-error-analysis"
  query_definition_log_group_names = ["/app/advanced-service"]
  query_definition_query_string    = <<-EOT
    fields @timestamp, @message, @logStream
    | filter @message like /ERROR/
    | stats count(*) as errorCount by bin(5m)
    | sort errorCount desc
    | limit 100
  EOT

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Example     = "advanced"
  }
}
