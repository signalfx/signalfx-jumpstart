provider "signalfx" {
  auth_token     = "${var.access_token}"
  api_url = "https://api.${var.realm}.signalfx.com"
}
# Every resource needs a unique name
resource "signalfx_detector" "application_delays" {
    name = "Customer latency is high"
    description = "SLI metric for customer experienced latency is higher than expectations"
    program_text = <<-EOF
signal = data('app.delay_seconds').max()
detect(when(signal > 3, '1m')).publish('Latency High')
    EOF
  rule {
        detect_label = "Latency High"
        description = "Latency is high for the last minute"
        severity = "Critical"
        #notifications = ["Teamabc123"] # Team ID goes here, send em a message!
  }
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
