resource "signalfx_detector" "httpcode_elb_5xx" {
  name         = "[SFx] AWS/ELB has high 5xx response ratio"
  description  = "Alerts when 10% of requests were 5xx for last 5m"
  program_text = <<-EOF
error = data('HTTPCode_ELB_5XX', filter=(filter('namespace', 'AWS/ELB') and filter('stat', 'count') and filter('LoadBalancerName', '*'))).publish(label='error', enable=False)
total = data('RequestCount', filter=(filter('namespace', 'AWS/ELB') and filter('stat', 'count') and filter('LoadBalancerName', '*'))).publish(label='total', enable=False)
detect(when(((error/total)*100) >= 10, lasting='5m')).publish('AWS/ELB 10% of requests were 5xx for last 5m')    
    EOF
  rule {
    detect_label = "AWS/ELB 10% of requests were 5xx for last 5m"
    severity     = "Critical"
  }
}
