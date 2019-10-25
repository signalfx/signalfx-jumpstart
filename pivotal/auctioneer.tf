resource "signalfx_detector" "pivotal_cloudfoundry_auctioneer_errors" {
  name         = "[SFx] Pivotal cloudFoundry Auctioneer errors"
  description  = "Alerts for various Pivotal CloudFoundry Auctioneer related error scenarios"
  program_text = <<-EOF


from signalfx.detectors.against_periods import against_periods
from signalfx.detectors.against_recent import against_recent

A = data('auctioneer.AuctioneerLRPAuctionsFailed', filter=filter('metric_source', 'cloudfoundry')).mean_plus_stddev(stddevs=1, over='5m').publish(label='A')
B = data('auctioneer.AuctioneerFetchStatesDuration', filter=filter('metric_source', 'cloudfoundry')).max(over='5m').publish(label='B')
C = (B/1000000000).publish(label='C')
D = data('auctioneer.AuctioneerLRPAuctionsStarted', filter=filter('metric_source', 'cloudfoundry')).mean_plus_stddev(stddevs=1, over='5m').publish(label='D')
E = data('auctioneer.AuctioneerTaskAuctionsFailed', filter=filter('metric_source', 'cloudfoundry')).mean_plus_stddev(stddevs=1, over='5m').publish(label='E')

detect((when((A >= 0.5) and (A <= 1)))).publish('Pivotal Cloudfoundry - AuctionsFailed - Minor.')
detect(when(A >= 1 )).publish('Pivotal Cloudfoundry - AuctionsFailed - Critical.')
detect((when((C >= 2) and (C <= 5)))).publish('Pivotal Cloudfoundry - FetchStatesDuration > 2 sec.')
detect(when(C >= 5)).publish('Pivotal Cloudfoundry - FetchStatesDuration > 5 sec.')
against_periods.detector_mean_std(stream=D, window_to_compare='10m', space_between_windows='1d', num_windows=4, fire_num_stddev=5, clear_num_stddev=3, discard_historical_outliers=True, orientation='above').publish('Pivotal Cloudfoundry - LRPAuctionsStarted Historical norm deviation.')
detect((when((E >= 0.5) and (E <= 1)))).publish('Pivotal Cloudfoundry - TaskAuctionsFailed - Minor.')
detect(when(E >= 1 )).publish('Pivotal Cloudfoundry - TaskAuctionsFailed - Critical.')

    EOF
  rule {
    detect_label = "Pivotal Cloudfoundry - AuctionsFailed - Minor."
    severity = "Minor"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - AuctionsFailed - Critical."
    severity = "Critical"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - FetchStatesDuration > 2 sec."
    severity = "Minor"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - FetchStatesDuration > 5 sec."
    severity = "Critical"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - LRPAuctionsStarted Historical norm deviation."
    severity = "Warning"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - TaskAuctionsFailed - Minor."
    severity = "Minor"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - TaskAuctionsFailed - Critical."
    severity = "Critical"
  }
}