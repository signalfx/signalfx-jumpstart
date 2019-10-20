resource "signalfx_detector" "azure__SQL_cpu_historical_norm" {
    name = "[SFx] Azure SQL database CPU % greater than historical norm"
    description = "Alerts when CPU usage for SQL Database for the last 10 minutes was significantly higher than normal, as compared to the last 3 hours"
    program_text = <<-EOF
from signalfx.detectors.against_recent import against_recent
A = data('cpu_percent', filter=filter('resource_type', 'Microsoft.Sql/servers/databases'), rollup='max').publish(label='A', enable=False)
against_recent.detector_mean_std(stream=A, current_window='10m', historical_window='3h', fire_num_stddev=4, clear_num_stddev=2.5, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('CPU % is significantly greater than the last 3 hours')
    EOF
  rule {
        detect_label = "CPU % is significantly greater than the last 3 hours"
        severity = "Warning"
  }
}
