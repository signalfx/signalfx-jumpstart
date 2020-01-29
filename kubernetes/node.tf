/*
resource "signalfx_detector" "k8s_node_cpu_imbalance" {
  name         = "${var.sfx_prefix} K8S Cluster CPU balance"
  description  = "Alerts when cluster CPU usage is imbalanced"
  program_text = <<-EOF
    A = data('container_cpu_utilization', filter=filter('kubernetes_cluster', '*') and filter('kubernetes_node', '*'), rollup='rate').sum(by=['kubernetes_node', 'kubernetes_cluster']).publish(label='A', enable=False)
    B = data('container_cpu_utilization', filter=filter('kubernetes_cluster', '*') and filter('kubernetes_node', '*')).sum(by=['kubernetes_node']).mean(by=['kubernetes_cluster']).publish(label='B', enable=False)
    C = ((A-B)/B).stddev(by=['kubernetes_cluster']).publish(label='C', enable=False)
    D = data('kube_node_info', filter=filter('kubernetes_cluster', '*'), rollup='count').count(by=['kubernetes_cluster']).publish(label='D', enable=False)
    E = (C*D).publish(label='K8S Cluster CPU usage is imbalanced')
  EOF
  rule {
    detect_label = "K8S Cluster CPU usage is imbalanced"
    severity     = "Critical"
    disabled     = true
    parameterized_body  = var.message_body
  }
}
*/
