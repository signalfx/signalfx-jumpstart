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
    severity = "Warning"
  }
}
resource "signalfx_detector" "rds_DiskQueueDepth_historical_error" {
  name = "[SFx] AWS/RDS rds_DiskQueueDepth for the last 10 minutes where significantly higher than normal, as compared to the last 12 hours"
  description = "Alerts when the number of outstanding IOs (read/write requests) in AWS/RD was significantly higher than normal for 10 minutes, as compared to the last 12 hours"
  program_text = <<-EOF
from signalfx.detectors.against_periods import against_periods
A = data('DiskQueueDepth', filter=filter('namespace', 'AWS/RDS')).mean_plus_stddev(stddevs=1, over='10m').publish(label='A', enable=False)
against_periods.detector_mean_std(stream=A, window_to_compare='30m', space_between_windows='12h', num_windows=4, fire_num_stddev=10, clear_num_stddev=3, discard_historical_outliers=True, orientation='above').publish('AWS/RDS outstanding IOs (read/write requests) for the last 10 minutes where significantly higher than normal, as compared to the last 12 hours')
    EOF
  rule {
    detect_label = "AWS/RDS outstanding IOs (read/write requests) for the last 10 minutes where significantly higher than normal, as compared to the last 12 hours"
    severity     = "Minor"
  }
}

resource "signalfx_detector" "rds_CPU_high_error" {
  name         = "[SFx] AWS/RDS CPUUtilization for the last 10 minutes was above 95%"
  description  = "Alerts when the cpu usage for AWS/RD was above 95% for ten minutes"
  program_text = <<-EOF
A = data('CPUUtilization', filter=filter('namespace', 'AWS/RDS')).mean_plus_stddev(stddevs=1, over='10m').publish(label='A', enable=False)
detect(when(A > 95)).publish('AWS/RDS CPU usage has been over 95% for the past 10 minutes')
  EOF
  rule {
    detect_label = "AWS/RDS CPU usage has been over 95% for the past 10 minutes"
    severity = "Critical"
  }
}

resource "signalfx_detector" "rds_cpu_historical_norm" {
  name = "[SFx] AWS RDS CPU % has been significantly higher for the past 10 minutes then the historical norm"
  description = "Alerts when CPU usage for SQL Database for the last 10 minutes was significantly higher than normal, as compared to the last 3 hours"
  program_text = <<-EOF
from signalfx.detectors.against_periods import against_periods
A = data('CPUUtilization', filter=filter('namespace', 'AWS/RDS')).mean().publish(label='A', enable=False)
against_periods.detector_mean_std(stream=A, window_to_compare='10m', space_between_windows='24h', num_windows=4, fire_num_stddev=5, clear_num_stddev=3, discard_historical_outliers=True, orientation='above').publish('AWS RDS CPU has been significantly higher for the past 10 minutes then the historical norm')
    EOF
  rule {
    detect_label = "AWS RDS CPU has been significantly higher for the past 10 minutes then the historical norm"
    severity     = "Warning"
  }
}
