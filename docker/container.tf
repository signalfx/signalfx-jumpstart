resource "signalfx_detector" "container_cpu_utilization" {
    name = "[SFx] Container CPU utilization % high"
    description = "Alerts when CPU Utilization % is between 70% & 80% for 10mins and > 80% for 5mins"
    program_text = <<-EOF
A = data('cpu.usage.total', filter=filter('plugin', 'docker'), extrapolation='null', maxExtrapolations=-1)
B = data('cpu.usage.system', filter=filter('plugin', 'docker'), extrapolation='null', maxExtrapolations=-1)
C = (A/B * 100).publish('Container CPU')
detect(when(C > 80, lasting='5m')).publish('Container CPU utilization % is above 80 for 5m')
detect(when(not (C > 80) and not (C < 70), lasting='10m')).publish('Container CPU utilization % is within 70 and 80 for 10m')
    EOF
  rule {
        detect_label = "Container CPU utilization % is within 70 and 80 for 10m"
        severity = "Warning"

  }
  rule {
        detect_label = "Container CPU utilization % is above 80 for 5m"
        severity = "Major"
  }
}
