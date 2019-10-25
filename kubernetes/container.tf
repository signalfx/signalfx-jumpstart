resource "signalfx_detector" "k8s_container_restarts" {
  name         = "[SFx] Container restart count is higher than normal"
  description  = "Container restart count in the last 5m are more than 2.5 standard deviations above the mean of its preceding 30m"
  program_text = <<-EOF
    from signalfx.detectors.against_recent import against_recent
    A = data('kubernetes.container_restart_count', filter=filter('kubernetes_cluster', '*') and filter('kubernetes_namespace', '*') and filter('deployment', '*', match_missing=True)).sum(by=['kubernetes_cluster', 'kubernetes_namespace', 'kubernetes_pod_name']).publish(label='A')
    against_recent.detector_mean_std(stream=A, current_window='5m', historical_window='30m', fire_num_stddev=2.5, clear_num_stddev=2, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('K8S Container restart count is higher than normal')
  EOF
  rule {
    detect_label = "K8S Container restarts higher than normal"
    severity = "Warning"
  }
}

resource "signalfx_detector" "k8s_container_cpu" {
  name         = "[SFx] Container CPU utilization is higher than normal"
  description  = "Container CPU utilization (%) in the last 5m is more than 2.5 standard deviations above the mean of its preceding 30m"
  program_text = <<-EOF
    from signalfx.detectors.against_recent import against_recent
    A = data('container_cpu_percent', filter=filter('kubernetes_cluster', '*') and filter('kubernetes_namespace', '*') and filter('sf_tags', '*', match_missing=True) and filter('deployment', '*', match_missing=True), rollup='rate').publish(label='A', enable=False)
    against_recent.detector_mean_std(stream=A, current_window='5m', historical_window='30m', fire_num_stddev=2.5, clear_num_stddev=2, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('K8S CPU% Detector')
  EOF
  rule {
    detect_label = "K8S Container CPU Usage higher than normal"
    severity = "Critical"
  }
}

resource "signalfx_detector" "k8s_container_memory" {
  name         = "[SFx] Container memory utilization is higher than normal, and increasing"
  description  = "Alerts when container memory utilization in the last 5m is more than 2.5 standard deviations above the mean of its preceding 30m"
  program_text = <<-EOF
    from signalfx.detectors.population_comparison import population
    A = data('container_memory_usage_bytes', filter=filter('kubernetes_cluster', '*') and filter('kubernetes_namespace', '*') and filter('sf_tags', '*', match_missing=True) and filter('deployment', '*')).publish(label='A', enable=False)
    population.detector(population_stream=A, group_by_property=None, fire_num_dev=2.5, fire_lasting=lasting('5m', 0.8), clear_num_dev=2, clear_lasting=lasting('5m', 0.8), strategy='median_MAD', orientation='above').publish('K8S Container Memory Usage Detector')
  EOF
  rule {
    detect_label = "K8S Container Memory Usage higher than normal, and increasing"
    severity = "Warning"
  }
}

