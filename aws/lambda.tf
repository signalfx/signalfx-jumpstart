resource "signalfx_detector" "lambda_error_rate" {
  name         = "[SFx] AWS/Lambda High Error Rate"
  description  = "AWS/Lambda function error rate is greater than 10 for the last 5m"
  program_text = <<-EOF
errors = data('Errors', filter=(filter('namespace', 'AWS/Lambda') and filter('FunctionName', '*') and filter('Resource', '*') and filter('stat', 'sum'))).publish(label='errors', enable=False)
detect((when(errors > 10, lasting='5m'))).publish('AWS/Lambda function error rate is greater than 10 for the last 5m')
    EOF
  rule {
    detect_label = "AWS/Lambda function error rate is greater than 10 for the last 5m"
    severity     = "Major"
  }
}
resource "signalfx_detector" "lambda_historical_duration_error" {
  name         = "[SFx] AWS/Lambda Historical duration error"
  description  = "AWS/Lambda Lambda duration has been greater then historical norm during the past 10 minutes"
  program_text = <<-EOF
from signalfx.detectors.against_periods import against_periods
A = data('Duration', filter=filter('namespace', 'AWS/Lambda')).mean().publish(label='A', enable=False)
against_periods.detector_mean_std(stream=A, window_to_compare='15m', space_between_windows='60m', num_windows=4, fire_num_stddev=3, clear_num_stddev=2, discard_historical_outliers=True, orientation='above').publish('AWS/Lambda Lambda duration has been greater then historical norm during the past 10 minutes')
    EOF
  rule {
    detect_label = "AWS/Lambda Lambda duration has been greater then historical norm during the past 10 minutes"
    severity     = "Minor"
  }
}
resource "signalfx_detector" "lambda_historical_coldstart_count_error" {
  name         = "[SFx] AWS/Lambda Historical coldstart count error"
  description  = "AWS/Lambda coldstart count has been greater then historical norm during the past 10 minutes"
  program_text = <<-EOF
from signalfx.detectors.against_periods import against_periods
A = data('function.cold_starts').publish(label='A', enable=False)
against_periods.detector_mean_std(stream=A, window_to_compare='10m', space_between_windows='24h', num_windows=4, fire_num_stddev=3, clear_num_stddev=2.5, discard_historical_outliers=True, orientation='above').publish('AWS/Lambda coldstart count has been greater then historical norm during the past 30 minutes')
    EOF
  rule {
    detect_label = "AWS/Lambda coldstart count has been greater then historical norm during the past 30 minutes"
    severity     = "Warning"
  }
}