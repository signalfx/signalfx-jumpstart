resource "signalfx_detector" "httpcode_elb_5xx" {
    name = "[SFx] AWS/ELB has high 5xx response ratio"
    description = "Alerts when 10% of requests were 5xx for last 5m"
    program_text = <<-EOF
error = data('HTTPCode_ELB_5XX', filter=(filter('namespace', 'AWS/ELB') and filter('stat', 'count') and filter('LoadBalancerName', '*'))).publish(label='error', enable=False)
total = data('RequestCount', filter=(filter('namespace', 'AWS/ELB') and filter('stat', 'count') and filter('LoadBalancerName', '*'))).publish(label='total', enable=False)
detect(when(((error/total)*100) >= 10, lasting='5m')).publish('AWS/ELB 10% of requests were 5xx for last 5m')    
    EOF
  rule {
        detect_label = "AWS/ELB 10% of requests were 5xx for last 5m"
        severity = "Critical"
  }
}

resource "signalfx_detector" "lambda_error_rate" {
    name = "[SFx] AWS/Lambda High Error Rate"
    description = "AWS/Lambda function error rate is greater than 10 for the last 5m"
    program_text = <<-EOF
errors = data('Errors', filter=(filter('namespace', 'AWS/Lambda') and filter('FunctionName', '*') and filter('Resource', '*') and filter('stat', 'sum'))).publish(label='errors', enable=False)
detect((when(errors > 10, lasting='5m'))).publish('AWS/Lambda function error rate is greater than 10 for the last 5m')
    EOF
  rule {
        detect_label = "AWS/Lambda function error rate is greater than 10 for the last 5m"
        severity = "Major"
  }
}

resource "signalfx_detector" "rds_free_space" {
    name = "[SFx] AWS/RDS Free Space Running Out"
    description = "RDS free disk space is expected to be below 20% in 12 hours"
    program_text = <<-EOF
from signalfx.detectors.countdown import countdown
free = data('FreeStorageSpace', filter=(filter('namespace', 'AWS/RDS') and filter('DBInstanceIdentifier', '*') and filter('stat', 'mean'))).publish(label='free', enable=False)
countdown.hours_left_stream_detector(stream=free, minimum_value=20, lower_threshold=12, fire_lasting=lasting('6m', 0.9), clear_threshold=84, clear_lasting=lasting('6m', 0.9), use_double_ewma=False).publish('AWS/RDS free disk space is expected to be below 20% in 12 hours')
    EOF
  rule {
        detect_label = "AWS/RDS free disk space is expected to be below 20% in 12 hours"
        severity = "Warning"
  }
}
