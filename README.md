# terraform-rohanmatre-cloudwatch

Terraform wrapper module that orchestrates all sub-modules from [terraform-aws-modules/cloudwatch/aws](https://registry.terraform.io/modules/terraform-aws-modules/cloudwatch/aws/latest) in a single, cohesive interface.

Each sub-module is **independently toggled** via `create_*` boolean flags — only enable the sub-modules you need. All sub-modules that reference a log group automatically resolve to the managed log group when `create_log_group = true`.

---

## Sub-modules included

| Sub-module | Toggle variable | Description |
|---|---|---|
| `log-group` | `create_log_group` | CloudWatch log group |
| `log-stream` | `create_log_stream` | Log stream inside a log group |
| `log-metric-filter` | `create_log_metric_filter` | Metric filter on a log group |
| `metric-alarm` | `create_metric_alarm` | Single-metric CloudWatch alarm |
| `composite-alarm` | `create_composite_alarm` | Composite alarm combining multiple alarms |
| `log-subscription-filter` | `create_log_subscription_filter` | Stream logs to Lambda/Firehose/Kinesis |
| `log-data-protection-policy` | `create_log_data_protection_policy` | PII data protection policy on a log group |
| `log-account-policy` | `create_log_account_policy` | Account-level log policy (DATA_PROTECTION or SUBSCRIPTION_FILTER) |
| `log-anomaly-detector` | `create_log_anomaly_detector` | ML-based log anomaly detection |
| `metric-stream` | `create_metric_stream` | Stream metrics to Kinesis Firehose |
| `query-definition` | `create_query_definition` | Saved CloudWatch Logs Insights query |

---

## Usage

### Log Group + Metric Filter + Alarm

```hcl
module "cloudwatch" {
  source = "../../"

  # Log Group
  create_log_group            = true
  log_group_name              = "/app/my-service"
  log_group_retention_in_days = 30

  # Metric Filter — count ERROR occurrences
  create_log_metric_filter        = true
  metric_filter_name              = "error-count"
  metric_filter_pattern           = "ERROR"
  metric_transformation_namespace = "MyApp"
  metric_transformation_name      = "ErrorCount"

  # Alarm — alert when errors spike
  create_metric_alarm         = true
  alarm_name                  = "my-service-errors"
  alarm_description           = "Alert when error rate exceeds threshold"
  alarm_comparison_operator   = "GreaterThanOrEqualToThreshold"
  alarm_evaluation_periods    = 1
  alarm_threshold             = 10
  alarm_period                = 60
  alarm_namespace             = "MyApp"
  alarm_metric_name           = "ErrorCount"
  alarm_statistic             = "Sum"
  alarm_treat_missing_data    = "notBreaching"
  alarm_actions               = ["arn:aws:sns:us-east-1:012345678901:alerts"]

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}
```

### Log Subscription Filter (forward to Firehose)

```hcl
module "cloudwatch" {
  source = "../../"

  create_log_group   = true
  log_group_name     = "/app/my-service"

  create_log_subscription_filter         = true
  subscription_filter_name               = "forward-to-firehose"
  subscription_filter_destination_arn    = "arn:aws:firehose:us-east-1:012345678901:deliverystream/logs"
  subscription_filter_pattern            = ""
  subscription_filter_role_arn           = "arn:aws:iam::012345678901:role/cw-logs-to-firehose"

  tags = { Terraform = "true" }
}
```

### Composite Alarm

```hcl
module "cloudwatch" {
  source = "../../"

  create_composite_alarm       = true
  composite_alarm_name         = "service-health"
  composite_alarm_description  = "Fires when either latency or error alarm is active"
  composite_alarm_rule         = "ALARM(latency-alarm) OR ALARM(error-alarm)"
  composite_alarm_actions      = ["arn:aws:sns:us-east-1:012345678901:pagerduty"]
  composite_alarm_actions_suppressor = {
    alarm            = "maintenance-suppressor"
    extension_period = 20
    wait_period      = 10
  }

  tags = { Terraform = "true" }
}
```

### Metric Stream (to Firehose)

```hcl
module "cloudwatch" {
  source = "../../"

  create_metric_stream        = true
  metric_stream_name          = "ec2-metrics"
  metric_stream_firehose_arn  = "arn:aws:firehose:us-east-1:012345678901:deliverystream/metrics"
  metric_stream_output_format = "json"
  metric_stream_role_arn      = "arn:aws:iam::012345678901:role/metric-stream-role"

  metric_stream_include_filter = {
    ec2 = {
      namespace    = "AWS/EC2"
      metric_names = ["CPUUtilization", "NetworkIn"]
    }
  }

  tags = { Terraform = "true" }
}
```

### Log Anomaly Detector

```hcl
module "cloudwatch" {
  source = "../../"

  create_log_anomaly_detector          = true
  anomaly_detector_name                = "api-logs-detector"
  anomaly_detector_log_group_arns      = ["arn:aws:logs:us-east-1:012345678901:log-group:/app/api"]
  anomaly_detector_evaluation_frequency = "FIVE_MIN"
  anomaly_detector_visibility_time     = 14
  anomaly_detector_enabled             = true
}
```

---

## Log Group Auto-Resolution

When `create_log_group = true`, the following sub-modules **automatically use the managed log group** unless their specific `*_log_group_name` override is set:

- `log-stream` → uses `module.log_group.cloudwatch_log_group_name`
- `log-metric-filter` → uses resolved log group (override: `metric_filter_log_group_name`)
- `log-subscription-filter` → uses resolved log group (override: `subscription_filter_log_group_name`)
- `log-data-protection-policy` → uses resolved log group (override: `data_protection_log_group_name`)

---

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.7 |
| aws | >= 5.81 |
| random | >= 2.0 |

## License

Apache-2.0 Licensed.
