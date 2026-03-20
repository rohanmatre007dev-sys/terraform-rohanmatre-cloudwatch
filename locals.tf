locals {
  # The resolved log group name — prefer the created one, fall back to provided name
  resolved_log_group_name = var.create_log_group ? module.log_group.cloudwatch_log_group_name : var.log_group_name

  # Auto-derive metric filter log group if not overridden
  effective_metric_filter_log_group = (
    var.metric_filter_log_group_name != null
    ? var.metric_filter_log_group_name
    : local.resolved_log_group_name
  )

  # Auto-derive subscription filter log group if not overridden
  effective_subscription_filter_log_group = (
    var.subscription_filter_log_group_name != null
    ? var.subscription_filter_log_group_name
    : local.resolved_log_group_name
  )

  # Auto-derive data protection log group if not overridden
  effective_data_protection_log_group = (
    var.data_protection_log_group_name != null
    ? var.data_protection_log_group_name
    : local.resolved_log_group_name
  )
}
