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
    severity = "Minor"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity debug."
    severity = "Warning"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity debug2."
    severity = "Warning"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity fatal."
    severity = "Critical"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - Sudden increase of n# of log messages of severity info."
    severity = "Warning"
  }

}


resource "signalfx_detector" "pivotal_cloudfoundry_auctioneer_errors" {
  name = "[SFx] Pivotal cloudFoundry Auctioneer errors"
  description = "Alerts for various Pivotal CloudFoundry Auctioneer related error scenarios"
  program_text = <<-EOF


from signalfx.detectors.against_periods import against_periods
from signalfx.detectors.against_recent import against_recent

A = data('auctioneer.AuctioneerLRPAuctionsFailed', filter=filter('metric_source', 'cloudfoundry')).mean_plus_stddev(stddevs=1, over='5m').publish(label='A')
B = data('auctioneer.AuctioneerFetchStatesDuration', filter=filter('metric_source', 'cloudfoundry')).max(over='5m').publish(label='B')
C = (B/1000000000).publish(label='C')
D = data('auctioneer.AuctioneerLRPAuctionsStarted', filter=filter('metric_source', 'cloudfoundry')).mean_plus_stddev(stddevs=1, over='5m').publish(label='D')


detect((when((A >= 0.5) and (A <= 1)))).publish('Pivotal Cloudfoundry - AuctionsFailed - Minor.')
detect(when(A >= 1 )).publish('Pivotal Cloudfoundry - AuctionsFailed - Critical.')

detect((when((C >= 2) and (C <= 5)))).publish('Pivotal Cloudfoundry - FetchStatesDuration > 2 sec.')
detect(when(C >= 5)).publish('Pivotal Cloudfoundry - FetchStatesDuration > 5 sec.')
against_periods.detector_mean_std(stream=D, window_to_compare='10m', space_between_windows='1d', num_windows=4, fire_num_stddev=5, clear_num_stddev=3, discard_historical_outliers=True, orientation='above').publish('Pivotal Cloudfoundry - AuctioneerLRPAuctionsStarted Historical norm deviation.')

    EOF
 rule {
    detect_label = "Pivotal Cloudfoundry - AuctionsFailed - Minor."
    severity     = "Minor"
  }
 rule {
    detect_label = "Pivotal Cloudfoundry - AuctionsFailed - Critical."
    severity     = "Critical"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - FetchStatesDuration > 2 sec."
    severity     = "Minor"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - FetchStatesDuration > 5 sec."
    severity     = "Critical"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - AuctioneerLRPAuctionsStarted Historical norm deviation."
    severity     = "Warning"
  }

}
//detect((when((A >= 1)).publish('Pivotal Cloudfoundry - AuctionsFailed - Critical.')

//