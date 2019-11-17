resource "signalfx_detector" "httpcode_elb_5xx" {
  name         = "[SFx] AWS/ELB has high 5XX response ratio"
  description  = "Alerts when 10% of requests were 5XX for last 5m"
  
  program_text = <<-EOF
    A = data('HTTPCode_ELB_5XX', filter=(filter('namespace', 'AWS/ELB') and filter('stat', 'count') and filter('LoadBalancerName', '*'))).publish(label='HTTPCode_ELB_5XX', enable=False)
    B = data('RequestCount', filter=(filter('namespace', 'AWS/ELB') and filter('stat', 'count') and filter('LoadBalancerName', '*'))).publish(label='RequestCount', enable=False)
    detect(when(((A/B)*100) >= 10, lasting='5m')).publish('AWS/ELB 10% of requests were 5XX for last 5m')    
  EOF

  rule {
    detect_label       = "AWS/ELB 10% of requests were 5XX for last 5m"
    severity           = "Critical"
    parameterized_body = "${var.message_body}"
  }
}