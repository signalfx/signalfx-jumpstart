resource "signalfx_detector" "disk_space_low" {
  name         = "[SFx] Low Disk Space"
  description  = "Alerts when a partition is filling up or total disk space will fill up within 24hrs"
  program_text = <<-EOF
    A = data('disk.utilization', filter=(not filter('plugin_instance', 'snap*'))).publish(label='A')
    detect(when(A >= 90)).publish('Disk space has filled upto 90%')
    detect(when(A >= 80 and A < 90)).publish('Disk space has filled upto 80%')
    from signalfx.detectors.countdown import countdown
    B = data('disk.summary_utilization').publish(label='B', enable=False)
    countdown.hours_left_stream_incr_detector(stream=B, maximum_capacity=100, lower_threshold=24, fire_lasting=lasting('15m', 1), clear_threshold=36, clear_lasting=lasting('15m', 1), use_double_ewma=False).publish('Disk space utilization is projected to reach 100% within 24 hours')
  EOF
  rule {
    detect_label = "Disk space has filled upto 80%"
    severity = "Major"
  }
  rule {
    detect_label = "Disk space has filled upto 90%"
    severity = "Critical"
  }
  rule {
    detect_label = "Disk space utilization is projected to reach 100% within 24 hours"
    severity = "Critical"
  }

}