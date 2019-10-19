provider "signalfx" {
  auth_token = "${var.access_token}"
  api_url    = "https://api.${var.realm}.signalfx.com"
}

resource "signalfx_detector" "httpcode_elb_5xx" {
    name = "[SFx] AWS/ELB has high 5xx response ratio"
    description = "Alerts when 10% of requests were 5xx for last 5m"
    program_text = <<-EOF
error = data('HTTPCode_ELB_5XX', filter=(filter('namespace', 'AWS/ELB') and filter('stat', 'count') and filter('LoadBalancerName', '*'))).publish(label='error', enable=False)
total = data('RequestCount', filter=(filter('namespace', 'AWS/ELB') and filter('stat', 'count') and filter('LoadBalancerName', '*'))).publish(label='total', enable=False)
detect(when(((error/total)*100) >= 10, lasting='5m')).publish('ELB 10% of requests were 5xx for last 5m')    
    EOF
  rule {
        detect_label = "ELB 10% of requests were 5xx for last 5m"
        severity = "Critical"
  }
}

resource "signalfx_detector" "cpu_historical_norm" {
    name = "[SFx] CPU utilization % greater than historical norm"
    description = "Alerts when CPU usage for this host for the last 10 minutes was significantly higher than normal, as compared to the last 24 hours"
    program_text = <<-EOF
from signalfx.detectors.against_recent import against_recent
A = data('cpu.utilization').publish(label='A', enable=False)
against_recent.detector_mean_std(stream=A, current_window='10m', historical_window='24h', fire_num_stddev=3, clear_num_stddev=2.5, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('CPU utilization is significantly greater than normal, and increasing')
    EOF
  rule {
        detect_label = "CPU utilization is significantly greater than normal, and increasing"
        severity = "Warning"
  }
}

resource "signalfx_detector" "lambda_error_rate" {
    name = "[SFx] Lambda High Error Rate"
    description = "Lambda function error rate is greater than 10 for the last 5m"
    program_text = <<-EOF
errors = data('Errors', filter=(filter('namespace', 'AWS/Lambda') and filter('FunctionName', '*') and filter('Resource', '*') and filter('stat', 'sum'))).publish(label='errors', enable=False)
detect((when(errors > 10, lasting='5m'))).publish('Lambda function error rate is greater than 10 for the last 5m')
    EOF
  rule {
        detect_label = "Lambda function error rate is greater than 10 for the last 5m"
        severity = "Major"
  }
}
