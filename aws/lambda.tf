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

