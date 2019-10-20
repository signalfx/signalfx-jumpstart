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

resource "signalfx_detector" "lambda_error_rate" {
    name = "[SFx] AWS/Lambda High Error Rate"
    description = "AWS/Lambda Lambda runtime greater then historical norm during the past 20 minutes"
    program_text = <<-EOF
  against_periods.detector_mean_std(stream=A, window_to_compare='20m', space_between_windows='1h', num_windows=4, fire_num_stddev=3, clear_num_stddev=2.5, discard_historical_outliers=True, orientation='above').publish('Lambda runtime greater then historical norm')   EOF
    EOF
  rule {
        detect_label = "AWS/Lambda Lambda runtime greater then historical norm during the past 20 minutes"
        severity = "Major"
  }
}