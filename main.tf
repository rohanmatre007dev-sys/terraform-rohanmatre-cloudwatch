################################################################################
# CloudWatch Module Wrapper
# Orchestrates cloudwatch sub-modules from terraform-aws-modules/cloudwatch/aws
################################################################################

################################################################################
# Log Group
################################################################################

module "log_group" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version = "~> 5.0"

  create = var.create_log_group

  name              = var.log_group_name
  name_prefix       = var.log_group_name_prefix
  retention_in_days = var.log_group_retention_in_days
  kms_key_id        = var.log_group_kms_key_id
  skip_destroy      = var.log_group_skip_destroy
  log_group_class   = var.log_group_class

  tags = var.tags
}

################################################################################
# Log Stream
################################################################################

module "log_stream" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-stream"
  version = "~> 5.0"

  create = var.create_log_stream

  name           = var.log_stream_name
  log_group_name = var.create_log_group ? module.log_group.cloudwatch_log_group_name : var.log_stream_log_group_name
}

################################################################################
# Log Metric Filter
################################################################################

module "log_metric_filter" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-metric-filter"
  version = "~> 5.0"

  create_cloudwatch_log_metric_filter = var.create_log_metric_filter

  log_group_name = var.create_log_group ? module.log_group.cloudwatch_log_group_name : var.metric_filter_log_group_name

  name    = var.metric_filter_name
  pattern = var.metric_filter_pattern

  metric_transformation_namespace     = var.metric_transformation_namespace
  metric_transformation_name          = var.metric_transformation_name
  metric_transformation_value         = var.metric_transformation_value
  metric_transformation_unit          = var.metric_transformation_unit
  metric_transformation_default_value = var.metric_transformation_default_value
  metric_transformation_dimensions    = var.metric_transformation_dimensions
}

################################################################################
# Metric Alarm
################################################################################

module "metric_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 5.0"

  create_metric_alarm = var.create_metric_alarm

  alarm_name          = var.alarm_name
  alarm_description   = var.alarm_description
  comparison_operator = var.alarm_comparison_operator
  evaluation_periods  = var.alarm_evaluation_periods
  threshold           = var.alarm_threshold
  threshold_metric_id = var.alarm_threshold_metric_id
  unit                = var.alarm_unit
  period              = var.alarm_period
  statistic           = var.alarm_statistic
  extended_statistic  = var.alarm_extended_statistic

  namespace   = var.alarm_namespace
  metric_name = var.alarm_metric_name
  dimensions  = var.alarm_dimensions

  metric_query = var.alarm_metric_query

  alarm_actions             = var.alarm_actions
  ok_actions                = var.alarm_ok_actions
  insufficient_data_actions = var.alarm_insufficient_data_actions

  actions_enabled                       = var.alarm_actions_enabled
  datapoints_to_alarm                   = var.alarm_datapoints_to_alarm
  evaluate_low_sample_count_percentiles = var.alarm_evaluate_low_sample_count_percentiles
  treat_missing_data                    = var.alarm_treat_missing_data

  tags = var.tags
}

################################################################################
# Composite Alarm
################################################################################

module "composite_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/composite-alarm"
  version = "~> 5.0"

  create = var.create_composite_alarm

  alarm_name        = var.composite_alarm_name
  alarm_description = var.composite_alarm_description
  alarm_rule        = var.composite_alarm_rule

  alarm_actions             = var.composite_alarm_actions
  ok_actions                = var.composite_alarm_ok_actions
  insufficient_data_actions = var.composite_alarm_insufficient_data_actions
  actions_enabled           = var.composite_alarm_actions_enabled

  actions_suppressor = var.composite_alarm_actions_suppressor

  tags = var.tags
}

################################################################################
# Log Subscription Filter
################################################################################

module "log_subscription_filter" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-subscription-filter"
  version = "~> 5.0"

  create = var.create_log_subscription_filter

  name            = var.subscription_filter_name
  log_group_name  = var.create_log_group ? module.log_group.cloudwatch_log_group_name : var.subscription_filter_log_group_name
  destination_arn = var.subscription_filter_destination_arn
  filter_pattern  = var.subscription_filter_pattern
  role_arn        = var.subscription_filter_role_arn
  distribution    = var.subscription_filter_distribution
}

################################################################################
# Log Data Protection Policy
################################################################################

module "log_data_protection_policy" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-data-protection-policy"
  version = "~> 5.0"

  create = var.create_log_data_protection_policy

  log_group_name                                = var.create_log_group ? module.log_group.cloudwatch_log_group_name : var.data_protection_log_group_name
  create_log_data_protection_policy             = var.create_log_data_protection_policy
  log_data_protection_policy_name               = var.log_data_protection_policy_name
  data_identifiers                              = var.data_protection_data_identifiers
  findings_destination_cloudwatch_log_group     = var.data_protection_findings_destination_cloudwatch_log_group
  findings_destination_firehose_delivery_stream = var.data_protection_findings_destination_firehose_stream
  findings_destination_s3_bucket                = var.data_protection_findings_destination_s3_bucket
}

################################################################################
# Log Account Policy
################################################################################

module "log_account_policy" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-account-policy"
  version = "~> 5.0"

  create = var.create_log_account_policy

  log_account_policy_name                       = var.log_account_policy_name
  log_account_policy_type                       = var.log_account_policy_type
  log_account_policy_scope                      = var.log_account_policy_scope
  create_log_data_protection_policy             = var.log_account_policy_create_data_protection
  log_data_protection_policy_name               = var.log_account_data_protection_policy_name
  data_identifiers                              = var.log_account_data_identifiers
  findings_destination_cloudwatch_log_group     = var.log_account_findings_destination_cloudwatch_log_group
  findings_destination_firehose_delivery_stream = var.log_account_findings_destination_firehose_stream
  findings_destination_s3_bucket                = var.log_account_findings_destination_s3_bucket
}

################################################################################
# Log Anomaly Detector
################################################################################

module "log_anomaly_detector" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-anomaly-detector"
  version = "~> 5.0"

  create = var.create_log_anomaly_detector

  detector_name           = var.anomaly_detector_name
  log_group_arns          = var.anomaly_detector_log_group_arns
  anomaly_visibility_time = var.anomaly_detector_visibility_time
  enabled                 = var.anomaly_detector_enabled
  evaluation_frequency    = var.anomaly_detector_evaluation_frequency
  filter_pattern          = var.anomaly_detector_filter_pattern
  kms_key_id              = var.anomaly_detector_kms_key_id
}

################################################################################
# Metric Stream
################################################################################

module "metric_stream" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-stream"
  version = "~> 5.0"

  create = var.create_metric_stream

  name          = var.metric_stream_name
  firehose_arn  = var.metric_stream_firehose_arn
  output_format = var.metric_stream_output_format
  role_arn      = var.metric_stream_role_arn

  include_filter           = var.metric_stream_include_filter
  exclude_filter           = var.metric_stream_exclude_filter
  statistics_configuration = var.metric_stream_statistics_configuration

  tags = var.tags
}

################################################################################
# Query Definition
################################################################################

module "query_definition" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/query-definition"
  version = "~> 5.0"

  create = var.create_query_definition

  name            = var.query_definition_name
  log_group_names = var.query_definition_log_group_names
  query_string    = var.query_definition_query_string
}
