resource "signalfx_detector" "k8s_pod_status" {
  name         = "[SFx] K8S Pod Waiting Status"
  description  = "Alerts when more pods than normal are in a waiting state"
  program_text = <<-EOF
    from signalfx.detectors.against_recent import against_recent
    A = data('kube_pod_container_status_waiting_reason', filter=(not filter('reason', 'ContainerCreating')) and filter('kubernetes_namespace', '*') and filter('kubernetes_pod_name', '*') and filter('reason', '*')).sum(over='5m').sum(by=['kubernetes_namespace', 'reason', 'kubernetes_pod_name']).above(0.5, inclusive=True).top(count=10).publish(label='A', enable=False)
    against_recent.detector_mean_std(stream=A, current_window='5m', historical_window='30m', fire_num_stddev=2, clear_num_stddev=2, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('K8S Pods in waiting state higher than normal')
  EOF
  rule {
    detect_label = "K8S Pods in waiting state higher than normal"
    severity     = "Critical"
  }
}

resource "signalfx_detector" "k8s_pods_active" {
  name         = "[SFx] K8S Pods active"
  description  = "Alerts when number of actrive pods changed significantly"
  program_text = <<-EOF
    from signalfx.detectors.against_recent import against_recent
    A = data('container_cpu_utilization', filter=filter('kubernetes_cluster', '*') and filter('kubernetes_namespace', '*') and filter('deployment', '*', match_missing=True) and filter('sf_tags', '*', match_missing=True)).sum(by=['kubernetes_cluster', 'kubernetes_namespace', 'kubernetes_pod_uid']).count().publish(label='A', enable=False)
    against_recent.detector_mean_std(stream=A, current_window='10m', historical_window='1h', fire_num_stddev=3.5, clear_num_stddev=3, orientation='out_of_band', ignore_extremes=True, calculation_mode='vanilla').publish('K8S Pods active changed significantly')
  EOF
  rule {
    detect_label = "K8S Pods active changed significantly"
    severity     = "Critical"
  }
}

resource "signalfx_detector" "k8s_pods_failed_pending_ratio" {
  name         = "[SFx] K8S Pod Phase Failed/Pending"
  description  = "Alerts when more Pods are in failed and pending phase than normal"
  program_text = <<-EOF
    from signalfx.detectors.against_recent import against_recent
    A = data('kube_pod_status_phase', filter=filter('metric_source', 'kube-state-metrics') and filter('kubernetes_cluster', '*') and filter('kubernetes_namespace', '*') and filter('metric_source', 'kube-state-metrics')).sum(by=['kubernetes_cluster', 'kubernetes_namespace']).publish(label='A', enable=False)
    B = data('kube_pod_status_phase', filter=filter('metric_source', 'kube-state-metrics') and filter('phase', 'Failed', 'Pending') and filter('kubernetes_cluster', '*') and filter('kubernetes_namespace', '*')).sum(by=['kubernetes_cluster', 'kubernetes_namespace']).publish(label='B', enable=False)
    C = ((B/A)*100).publish(label='C', enable=False)
    against_recent.detector_mean_std(stream=C, current_window='5m', historical_window='30m', fire_num_stddev=2.5, clear_num_stddev=2, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('K8S Pods failed and pending ratio')
  EOF
  rule {
    detect_label = "K8S Pods failed and pending ratio"
    severity     = "Critical"
  }
}

