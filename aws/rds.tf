resource "signalfx_detector" "rds_free_space" {
  name         = "[SFx] AWS/RDS Free Space Running Out"
  description  = "RDS free disk space is expected to be below 20% in 12 hours"
  program_text = <<-EOF
from signalfx.detectors.countdown import countdown
free = data('FreeStorageSpace', filter=(filter('namespace', 'AWS/RDS') and filter('DBInstanceIdentifier', '*') and filter('stat', 'mean'))).publish(label='free', enable=False)
countdown.hours_left_stream_detector(stream=free, minimum_value=20, lower_threshold=12, fire_lasting=lasting('6m', 0.9), clear_threshold=84, clear_lasting=lasting('6m', 0.9), use_double_ewma=False).publish('AWS/RDS free disk space is expected to be below 20% in 12 hours')
    EOF
  rule {
    detect_label = "AWS/RDS free disk space is expected to be below 20% in 12 hours"
    severity     = "Warning"
  }
}

