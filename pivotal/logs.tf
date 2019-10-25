resource "signalfx_detector" "pivotal_cloudfoundry_log_errors" {
  name         = "[SFx] Pivotal cloudFoundry Log errors"
  description  = "Alerts for various Pivotal CloudFoundry Log related error scenarios"
  program_text = <<-EOF


from signalfx.detectors.against_periods import against_periods
from signalfx.detectors.against_recent import against_recent

A = data('cc.log_count.error').publish(label='A', enable=False)
B = data('cc.log_count.debug').publish(label='B', enable=False)
C = data('cc.log_count.debug2').publish(label='C', enable=False)
D = data('cc.log_count.fatal').publish(label='D', enable=False)
E = data('cc.log_count.info').publish(label='E', enable=False)

against_recent.detector_mean_std(stream=A, current_window='10m', historical_window='24h', fire_num_stddev=4, clear_num_stddev=2.5, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity error.')
against_recent.detector_mean_std(stream=B, current_window='10m', historical_window='24h', fire_num_stddev=4, clear_num_stddev=2.5, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity debug.')
against_recent.detector_mean_std(stream=C, current_window='10m', historical_window='24h', fire_num_stddev=4, clear_num_stddev=2.5, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity debug2.')
against_recent.detector_mean_std(stream=B, current_window='10m', historical_window='24h', fire_num_stddev=4, clear_num_stddev=2.5, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity fatal.')
against_recent.detector_mean_std(stream=C, current_window='10m', historical_window='24h', fire_num_stddev=4, clear_num_stddev=2.5, orientation='above', ignore_extremes=True, calculation_mode='vanilla').publish('Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity info.')

    EOF
  rule {
    detect_label = "Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity error."
    severity     = "Minor"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity debug."
    severity     = "Warning"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity debug2."
    severity     = "Warning"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity fatal."
    severity     = "Critical"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity info."
    severity     = "Warning"
  }

}