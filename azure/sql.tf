rresource "signalfx_detector" "azure_DB_cpu_historical_norm" {
  name         = "[SFx] Azure SQL Database CPU % greater than historical norm"
  description  = "Alerts when CPU usage for SQL Database for the last 10 minutes was significantly higher than normal, as compared to the last 3 hours"
  program_text = <<-EOF
from signalfx.detectors.against_recent import against_recent
A = data('cpu_percent', filter=filter('resource_type', 'Microsoft.Sql/servers/databases'), rollup='max').publish(label='A', enable=False)
against_recent.detector_mean_std(stream=A, current_window='10m', historical_window='3h', fire_num_stddev=4, clear_num_stddev=2.5, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('Azure SQL database CPU % is significantly greater than the last 3 hours')
    EOF
  rule {
    detect_label = "Azure SQL database CPU % is significantly greater than the last 3 hours"
    severity     = "Warning"
  }
}

resource "signalfx_detector" "azure_SQL_cpu_historical_norm" {
  name         = "[SFx] Azure SQL ElasticPool CPU % greater than historical norm"
  description  = "Alerts when CPU usage for SQL Database for the last 10 minutes was significantly higher than normal, as compared to the last 3 hours"
  program_text = <<-EOF
from signalfx.detectors.against_recent import against_recent
A = data('cpu_percent', filter=filter('resource_type', 'Microsoft.Sql/servers/elasticpools')).max().publish(label='A', enable=False)
against_recent.detector_mean_std(stream=A, current_window='10m', historical_window='3h', fire_num_stddev=4, clear_num_stddev=2.5, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('Azure SQL Elasticpools CPU % is significantly greater than the last 3 hours')
    EOF
  rule {
    detect_label = "Azure SQL Elasticpools CPU % is significantly greater than the last 3 hours"
    severity     = "Warning"
  }
}

resource "signalfx_detector" "azure_SQL_DTU_Percentage_High" {
  name         = "[SFx] Azure SQL DTU Consumption % is greater than 80 over the past 10 minutes'"
  description  = "Alerts when DTU Consumption % for SQL servers is above 80% for the last 10 minutes"
  program_text = <<-EOF
A = data('dtu_consumption_percent', filter=filter('resource_type', 'Microsoft.Sql/servers')).mean(over='10m').publish(label='A', enable=False)
detect(when(A > 80)).publish('Azure SQL DTU Consumption % is greater than 80 over the past 10 minutes')
    EOF
  rule {
    detect_label = "Azure SQL DTU Consumption % is greater than 80 over the past 10 minutes"
    severity     = "Minor"
  }
}

resource "signalfx_detector" "azure_DB_SQL_cpu_historical_norm" {
  name         = "[SFx] Azure SQL Database CPU at 100%"
  description  = "Alerts when CPU usage for SQL Database for the last 10 minutes was significantly higher than normal, as compared to the last 3 hours"
  program_text = <<-EOF
A = data('cpu_percent', filter=filter('resource_type', 'Microsoft.Sql/servers/databases'), rollup='average').mean(over='10m').publish(label='A', enable=False)
detect(when(A > 99)).publish('Azure SQL Database CPU % has been at 100% for the past 10 minutes')
    EOF
  rule {
    detect_label = "Azure SQL Database CPU % has been at 100% for the past 10 minutes"
    severity     = "Critical"
  }
}

resource "signalfx_detector" "azure_EP_cpu_historical_norm" {
  name         = "[SFx] Azure SQL elasticpools CPU at 100% "
  description  = "Alerts when CPU usage for SQL Database for the last 10 minutes was significantly higher than normal, as compared to the last 3 hours"
  program_text = <<-EOF
A = data('cpu_percent', filter=filter('resource_type', 'Microsoft.Sql/servers/elasticpools'), rollup='average').mean(over='10m').publish(label='A', enable=False)
detect(when(A > 99)).publish('Azure elasticpools CPU % has been at 100% for the past 10 minutes')
    EOF
  rule {
    detect_label = "Azure elasticpools CPU % has been at 100% for the past 10 minutes"
    severity     = "Critical"
  }
}

resource "signalfx_detector" "azure_EP_Physical_dataread_high_error" {
  name         = "[SFx] Azure SQL elasticpools data read above 94%"
  description  = "Alerts when data reads for SQL elasticpools have been above 94%"
  program_text = <<-EOF
A = data('physical_data_read_percent', filter=filter('resource_type', 'Microsoft.Sql/servers/elasticpools')).mean_plus_stddev(stddevs=1, over='5m').publish(label='A', enable=False)
detect(when(A > 94)).publish('Azure SQL elasticpools data read above 95%')
    EOF
  rule {
    detect_label = "Azure SQL elasticpools data read above 95%"
    severity     = "Warning"
  }
}

resource "signalfx_detector" "azure_DB_SQL_Physical_dataread_high_error" {
  name         = "[SFx] Azure SQL Database data read above 94%"
  description  = "Alerts when data reads have been above 94%"
  program_text = <<-EOF
A = data('physical_data_read_percent', filter=filter('resource_type', 'Microsoft.Sql/servers/databases')).mean_plus_stddev(stddevs=1, over='5m').publish(label='A', enable=False)
detect(when(A > 94)).publish('Azure SQL database data read above 95%')
    EOF
  rule {
    detect_label = "Azure SQL database data read above 95%"
    severity     = "Warning"
  }
}
