################################################################################
# Common
################################################################################

variable "tags" {
  description = "A map of tags to add to all taggable resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Log Group
################################################################################

variable "create_log_group" {
  description = "Whether to create a CloudWatch log group"
  type        = bool
  default     = false
}

variable "log_group_name" {
  description = "The name of the log group"
  type        = string
  default     = null
}

variable "log_group_name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default     = null
}

variable "log_group_retention_in_days" {
  description = "Specifies the number of days to retain log events. Possible values: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, or 0 (never expire)"
  type        = number
  default     = null
}

variable "log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  type        = string
  default     = null
}

variable "log_group_skip_destroy" {
  description = "Set to true to not delete the log group at destroy time"
  type        = bool
  default     = false
}

variable "log_group_class" {
  description = "Specified the log class of the log group. Possible values are: STANDARD or INFREQUENT_ACCESS"
  type        = string
  default     = null
}

################################################################################
# Log Stream
################################################################################

variable "create_log_stream" {
  description = "Whether to create a CloudWatch log stream"
  type        = bool
  default     = false
}

variable "log_stream_name" {
  description = "The name of the log stream"
  type        = string
  default     = null
}

variable "log_stream_log_group_name" {
  description = "The name of the log group to associate the stream with. Used when create_log_group = false."
  type        = string
  default     = null
}

################################################################################
# Log Metric Filter
################################################################################

variable "create_log_metric_filter" {
  description = "Whether to create a CloudWatch log metric filter"
  type        = bool
  default     = false
}

variable "metric_filter_name" {
  description = "A name for the metric filter"
  type        = string
  default     = null
}

variable "metric_filter_pattern" {
  description = "A valid CloudWatch Logs filter pattern for extracting metric data out of ingested log events. See Filter and Pattern Syntax."
  type        = string
  default     = ""
}

variable "metric_filter_log_group_name" {
  description = "The name of the log group to associate the metric filter with. Defaults to the created log group when create_log_group = true."
  type        = string
  default     = null
}

variable "metric_transformation_namespace" {
  description = "The destination namespace of the CloudWatch metric"
  type        = string
  default     = null
}

variable "metric_transformation_name" {
  description = "The name of the CloudWatch metric to which the monitored log information should be published"
  type        = string
  default     = null
}

variable "metric_transformation_value" {
  description = "What to publish to the metric. For example, if you're counting the occurrences of a particular term, the value will be 1"
  type        = string
  default     = "1"
}

variable "metric_transformation_unit" {
  description = "The unit to assign to the metric. Valid values are: Seconds, Microseconds, Milliseconds, Bytes, Kilobytes, Megabytes, Gigabytes, Terabytes, Bits, Kilobits, Megabits, Gigabits, Terabits, Percent, Count, Bytes/Second, Kilobytes/Second, Megabytes/Second, Gigabytes/Second, Terabytes/Second, Bits/Second, Kilobits/Second, Megabits/Second, Gigabits/Second, Terabits/Second, Count/Second, or None"
  type        = string
  default     = null
}

variable "metric_transformation_default_value" {
  description = "The value to emit when a filter pattern does not match a log event"
  type        = string
  default     = null
}

variable "metric_transformation_dimensions" {
  description = "A map of fields to use as dimensions for the metric"
  type        = map(string)
  default     = null
}

################################################################################
# Metric Alarm
################################################################################

variable "create_metric_alarm" {
  description = "Whether to create a CloudWatch metric alarm"
  type        = bool
  default     = false
}

variable "alarm_name" {
  description = "The descriptive name for the alarm"
  type        = string
  default     = null
}

variable "alarm_description" {
  description = "The description for the alarm"
  type        = string
  default     = null
}

variable "alarm_comparison_operator" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. Valid values: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold, LessThanLowerOrGreaterThanUpperThreshold, LessThanLowerThreshold, GreaterThanUpperThreshold"
  type        = string
  default     = null
}

variable "alarm_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold"
  type        = number
  default     = 1
}

variable "alarm_threshold" {
  description = "The value against which the specified statistic is compared"
  type        = number
  default     = null
}

variable "alarm_threshold_metric_id" {
  description = "If this is an alarm based on an anomaly detection model, make this value match the ID of the ANOMALY_DETECTION_BAND function"
  type        = string
  default     = null
}

variable "alarm_unit" {
  description = "The unit for the alarm's associated metric"
  type        = string
  default     = null
}

variable "alarm_period" {
  description = "The period in seconds over which the specified statistic is applied"
  type        = number
  default     = null
}

variable "alarm_statistic" {
  description = "The statistic to apply to the alarm's associated metric. Valid values: SampleCount, Average, Sum, Minimum, Maximum"
  type        = string
  default     = null
}

variable "alarm_extended_statistic" {
  description = "The percentile statistic for the metric. Conflicts with statistic"
  type        = string
  default     = null
}

variable "alarm_namespace" {
  description = "The namespace for the alarm's associated metric"
  type        = string
  default     = null
}

variable "alarm_metric_name" {
  description = "The name for the alarm's associated metric"
  type        = string
  default     = null
}

variable "alarm_dimensions" {
  description = "The dimensions for the alarm's associated metric"
  type        = map(string)
  default     = null
}

variable "alarm_metric_query" {
  description = "Enables you to create an alarm based on a metric math expression"
  type        = any
  default     = []
}

variable "alarm_actions" {
  description = "The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an ARN."
  type        = list(string)
  default     = []
}

variable "alarm_ok_actions" {
  description = "The list of actions to execute when this alarm transitions into an OK state"
  type        = list(string)
  default     = []
}

variable "alarm_insufficient_data_actions" {
  description = "The list of actions to execute when this alarm transitions into an INSUFFICIENT_DATA state"
  type        = list(string)
  default     = []
}

variable "alarm_actions_enabled" {
  description = "Indicates whether or not actions should be executed during any changes to the alarm state"
  type        = bool
  default     = true
}

variable "alarm_datapoints_to_alarm" {
  description = "The number of datapoints that must be breaching to trigger the alarm"
  type        = number
  default     = null
}

variable "alarm_evaluate_low_sample_count_percentiles" {
  description = "Used only for alarms based on percentiles. Valid values: evaluate or ignore"
  type        = string
  default     = null
}

variable "alarm_treat_missing_data" {
  description = "Sets how this alarm is to handle missing data points. Valid values: missing, ignore, breaching, notBreaching"
  type        = string
  default     = "missing"
}

################################################################################
# Composite Alarm
################################################################################

variable "create_composite_alarm" {
  description = "Whether to create a CloudWatch composite alarm"
  type        = bool
  default     = false
}

variable "composite_alarm_name" {
  description = "The descriptive name for the composite alarm"
  type        = string
  default     = null
}

variable "composite_alarm_description" {
  description = "The description for the composite alarm"
  type        = string
  default     = null
}

variable "composite_alarm_rule" {
  description = "An expression that specifies which other alarms are to be evaluated to determine this composite alarm's states"
  type        = string
  default     = null
}

variable "composite_alarm_actions" {
  description = "The set of actions to execute when this alarm transitions to the ALARM state"
  type        = list(string)
  default     = []
}

variable "composite_alarm_ok_actions" {
  description = "The set of actions to execute when this alarm transitions to an OK state"
  type        = list(string)
  default     = []
}

variable "composite_alarm_insufficient_data_actions" {
  description = "The set of actions to execute when this alarm transitions to the INSUFFICIENT_DATA state"
  type        = list(string)
  default     = []
}

variable "composite_alarm_actions_enabled" {
  description = "Indicates whether or not actions should be executed during any changes to the alarm state of the composite alarm"
  type        = bool
  default     = true
}

variable "composite_alarm_actions_suppressor" {
  description = "Actions suppressor configuration for the composite alarm"
  type = object({
    alarm            = string
    extension_period = number
    wait_period      = number
  })
  default = null
}

################################################################################
# Log Subscription Filter
################################################################################

variable "create_log_subscription_filter" {
  description = "Whether to create a CloudWatch log subscription filter"
  type        = bool
  default     = false
}

variable "subscription_filter_name" {
  description = "A name for the subscription filter"
  type        = string
  default     = null
}

variable "subscription_filter_log_group_name" {
  description = "The name of the log group to associate the subscription filter with. Defaults to the created log group when create_log_group = true."
  type        = string
  default     = null
}

variable "subscription_filter_destination_arn" {
  description = "The ARN of the destination to deliver matching log events to (Lambda, Kinesis stream, Kinesis Firehose)"
  type        = string
  default     = null
}

variable "subscription_filter_pattern" {
  description = "A valid CloudWatch Logs filter pattern for subscribing to a filtered stream of log events"
  type        = string
  default     = ""
}

variable "subscription_filter_role_arn" {
  description = "The ARN of an IAM role that grants CloudWatch Logs permissions to deliver ingested log events to the destination"
  type        = string
  default     = null
}

variable "subscription_filter_distribution" {
  description = "The method used to distribute log data to the destination. Valid values: Random, ByLogStream"
  type        = string
  default     = null
}

################################################################################
# Log Data Protection Policy
################################################################################

variable "create_log_data_protection_policy" {
  description = "Whether to create a CloudWatch log data protection policy"
  type        = bool
  default     = false
}

variable "data_protection_log_group_name" {
  description = "The name of the log group to attach the data protection policy to. Defaults to the created log group when create_log_group = true."
  type        = string
  default     = null
}

variable "log_data_protection_policy_name" {
  description = "Name of the data protection policy"
  type        = string
  default     = null
}

variable "data_protection_data_identifiers" {
  description = "List of data identifier ARNs for the data protection policy"
  type        = list(string)
  default     = []
}

variable "data_protection_findings_destination_cloudwatch_log_group" {
  description = "CloudWatch log group name to send findings to"
  type        = string
  default     = null
}

variable "data_protection_findings_destination_firehose_stream" {
  description = "Kinesis Firehose delivery stream ARN to send findings to"
  type        = string
  default     = null
}

variable "data_protection_findings_destination_s3_bucket" {
  description = "S3 bucket ARN to send findings to"
  type        = string
  default     = null
}

################################################################################
# Log Account Policy
################################################################################

variable "create_log_account_policy" {
  description = "Whether to create a CloudWatch log account policy"
  type        = bool
  default     = false
}

variable "log_account_policy_name" {
  description = "Name of the account policy"
  type        = string
  default     = null
}

variable "log_account_policy_type" {
  description = "Type of account policy. Valid values: DATA_PROTECTION_POLICY, SUBSCRIPTION_FILTER_POLICY"
  type        = string
  default     = null
}

variable "log_account_policy_scope" {
  description = "Currently defaults to ALL (all log groups in the account)"
  type        = string
  default     = null
}

variable "log_account_policy_create_data_protection" {
  description = "Whether to create the data protection policy within the account policy"
  type        = bool
  default     = false
}

variable "log_account_data_protection_policy_name" {
  description = "Name of the data protection policy within the account policy"
  type        = string
  default     = null
}

variable "log_account_data_identifiers" {
  description = "List of data identifier ARNs for the account-level data protection policy"
  type        = list(string)
  default     = []
}

variable "log_account_findings_destination_cloudwatch_log_group" {
  description = "CloudWatch log group to send account policy findings to"
  type        = string
  default     = null
}

variable "log_account_findings_destination_firehose_stream" {
  description = "Kinesis Firehose stream ARN to send account policy findings to"
  type        = string
  default     = null
}

variable "log_account_findings_destination_s3_bucket" {
  description = "S3 bucket ARN to send account policy findings to"
  type        = string
  default     = null
}

################################################################################
# Log Anomaly Detector
################################################################################

variable "create_log_anomaly_detector" {
  description = "Whether to create a CloudWatch log anomaly detector"
  type        = bool
  default     = false
}

variable "anomaly_detector_name" {
  description = "The name of the anomaly detector"
  type        = string
  default     = null
}

variable "anomaly_detector_log_group_arns" {
  description = "List of log group ARNs to associate with the anomaly detector"
  type        = list(string)
  default     = []
}

variable "anomaly_detector_visibility_time" {
  description = "The number of days to have visibility on an anomaly. After this time period, a detected anomaly is automatically baselined"
  type        = number
  default     = 7
}

variable "anomaly_detector_enabled" {
  description = "Whether the anomaly detector is enabled"
  type        = bool
  default     = true
}

variable "anomaly_detector_evaluation_frequency" {
  description = "The frequency of anomaly detection. Valid values: ONE_MIN, FIVE_MIN, TEN_MIN, FIFTEEN_MIN, THIRTY_MIN, ONE_HOUR"
  type        = string
  default     = "FIVE_MIN"
}

variable "anomaly_detector_filter_pattern" {
  description = "A symbolic description of how CloudWatch Logs should interpret the data in each log event"
  type        = string
  default     = null
}

variable "anomaly_detector_kms_key_id" {
  description = "The ARN of the KMS key to use to encrypt the anomaly detector data"
  type        = string
  default     = null
}

################################################################################
# Metric Stream
################################################################################

variable "create_metric_stream" {
  description = "Whether to create a CloudWatch metric stream"
  type        = bool
  default     = false
}

variable "metric_stream_name" {
  description = "The name of the metric stream"
  type        = string
  default     = null
}

variable "metric_stream_firehose_arn" {
  description = "The ARN of the Kinesis Firehose delivery stream to use for the metric stream"
  type        = string
  default     = null
}

variable "metric_stream_output_format" {
  description = "Output format for the metric stream. Valid values: json, opentelemetry0.7, opentelemetry1.0"
  type        = string
  default     = "json"
}

variable "metric_stream_role_arn" {
  description = "The ARN of the IAM role that allows the metric stream to write to the Kinesis Firehose"
  type        = string
  default     = null
}

variable "metric_stream_include_filter" {
  description = "A map of namespace include filters. Conflicts with exclude_filter."
  type        = any
  default     = {}
}

variable "metric_stream_exclude_filter" {
  description = "A map of namespace exclude filters. Conflicts with include_filter."
  type        = any
  default     = {}
}

variable "metric_stream_statistics_configuration" {
  description = "List of additional statistics to include in the metric stream"
  type        = any
  default     = []
}

variable "metric_stream_include_linked_accounts_metrics" {
  description = "Whether to include metrics from linked accounts in the metric stream"
  type        = bool
  default     = null
}

################################################################################
# Query Definition
################################################################################

variable "create_query_definition" {
  description = "Whether to create a CloudWatch Logs Insights query definition"
  type        = bool
  default     = false
}

variable "query_definition_name" {
  description = "The name of the query definition"
  type        = string
  default     = null
}

variable "query_definition_log_group_names" {
  description = "A list of log group names to associate with the query definition"
  type        = list(string)
  default     = []
}

variable "query_definition_query_string" {
  description = "The query to save. For example: fields @timestamp, @message | sort @timestamp desc | limit 25"
  type        = string
  default     = null
}
