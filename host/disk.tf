resource "signalfx_detector" "disk_partition_space_low" {
  name         = "[SFx] Low Disk Space"
  description  = "Alerts when space on root partition is at 80% or 90%"
  program_text = <<-EOF
    disk_usage = data('disk.utilization', filter=(not filter('plugin_instance', 'root'))).publish(label='disk_usage', enable=False)
    detect(when(disk_usage >= 90)).publish('Disk space has filled upto 90%')
    detect(when(disk_usage >= 80 and disk_usage < 90)).publish('Disk space has filled upto 80%')
  EOF
  rule {
    detect_label = "Disk space has filled upto 80%"
    severity     = "Major"
  }
  rule {
    detect_label = "Disk space has filled upto 90%"
    severity     = "Critical"
  }
}