resource "signalfx_detector" "k8s_pods_active" {
  name         = "${var.sfx_prefix} K8S Pods active"
  description  = "Alerts when number of active pods changed significantly"
  program_text = <<-EOF
    from signalfx.detectors.against_recent import against_recent
    A = data('container_cpu_utilization', filter=filter('kubernetes_cluster', '*') and filter('kubernetes_namespace', '*') and filter('deployment', '*', match_missing=True) and filter('sf_tags', '*', match_missing=True)).sum(by=['kubernetes_cluster', 'kubernetes_namespace', 'kubernetes_pod_uid']).count().publish(label='A', enable=False)
    against_recent.detector_mean_std(stream=A, current_window='10m', historical_window='1h', fire_num_stddev=3.5, clear_num_stddev=3, orientation='out_of_band', ignore_extremes=True, calculation_mode='vanilla').publish('K8S Pods active changed significantly')
  EOF
  rule {
    detect_label       = "K8S Pods active changed significantly"
    severity           = "Critical"
    parameterized_body = var.message_body
  }
}

resource "signalfx_detector" "k8s_pods_failed_pending_ratio" {
  name         = "${var.sfx_prefix} K8S Pod Phase Failed/Pending"
  description  = "Alerts when more Pods are in failed and pending phase than normal"
  program_text = <<-EOF
    from signalfx.detectors.against_recent import against_recent
    A = data('kubernetes.pod_phase', filter=filter('kubernetes_cluster', '*') and filter('kubernetes_namespace', '*') and filter('metric_source', 'kubernetes')).below(1, inclusive=True).count(by=['kubernetes_cluster', 'kubernetes_namespace']).publish(label='A')
    B = data('kubernetes.pod_phase', filter=filter('metric_source', 'kubernetes') and filter('kubernetes_cluster', '*') and filter('kubernetes_namespace', '*')).above(4, inclusive=True).count(by=['kubernetes_cluster', 'kubernetes_namespace']).publish(label='B')
    D = data('kubernetes.pod_phase', filter=filter('kubernetes_cluster', '*') and filter('kubernetes_namespace', '*') and filter('metric_source', 'kubernetes')).count(by=['kubernetes_cluster', 'kubernetes_namespace']).publish(label='D')
    E = ((A+B/D)*100).publish(label='E')
    against_recent.detector_mean_std(stream=E, current_window='5m', historical_window='30m', fire_num_stddev=2.5, clear_num_stddev=2, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('K8S Pods failed and pending ratio')
  EOF
  rule {
    detect_label       = "K8S Pods failed and pending ratio"
    severity           = "Minor"
    parameterized_body = var.message_body
  }
}

