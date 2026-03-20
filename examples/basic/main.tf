provider "aws" {
  region = "us-east-1"
}

################################################################################
# Basic: Log Group + Log Stream + Metric Filter + Metric Alarm
################################################################################

module "cloudwatch" {
  source = "../../"

  # Log Group
  create_log_group            = true
  log_group_name              = "/app/basic-service"
  log_group_retention_in_days = 14
  log_group_class             = "STANDARD"

  # Log Stream
  create_log_stream = true
  log_stream_name   = "application"

  # Metric Filter — count ERROR lines
  create_log_metric_filter        = true
  metric_filter_name              = "error-count"
  metric_filter_pattern           = "ERROR"
  metric_transformation_namespace = "BasicService"
  metric_transformation_name      = "ErrorCount"
  metric_transformation_value     = "1"
  metric_transformation_unit      = "Count"

  # Metric Alarm — SNS alert when errors reach threshold
  create_metric_alarm       = true
  alarm_name                = "basic-service-errors"
  alarm_description         = "Alert when ErrorCount reaches 5 within a 60-second period"
  alarm_comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_evaluation_periods  = 1
  alarm_threshold           = 5
  alarm_period              = 60
  alarm_namespace           = "BasicService"
  alarm_metric_name         = "ErrorCount"
  alarm_statistic           = "Sum"
  alarm_treat_missing_data  = "notBreaching"
  alarm_actions             = ["arn:aws:sns:us-east-1:012345678901:basic-alerts"]

  # Query Definition for Insights
  create_query_definition          = true
  query_definition_name            = "recent-errors"
  query_definition_log_group_names = ["/app/basic-service"]
  query_definition_query_string    = <<-EOT
    fields @timestamp, @message
    | filter @message like /ERROR/
    | sort @timestamp desc
    | limit 50
  EOT

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Example     = "basic"
  }
}
