resource "signalfx_detector" "pivotal_cloudfoundry_diego_errors" {
  name         = "[SFx] Pivotal cloudFoundry diego errors"
  description  = "Alerts for various Pivotal CloudFoundry Diego related error scenarios"
  program_text = <<-EOF


from signalfx.detectors.against_periods import against_periods
from signalfx.detectors.against_recent import against_recent

A = data('bbs.ConvergenceLRPDuration', filter=filter('metric_source', 'cloudfoundry'), rollup='max').max(over='15m').publish(label='A')
B = (A/1000000000).publish(label='B')

detect((when((A >= 10) and (A < 20)))).publish('Pivotal Cloudfoundry - ConvergenceLRPDuration - Minor.')
detect(when(A >= 20 )).publish('Pivotal Cloudfoundry - ConvergenceLRPDuration - Critical.')

    EOF
  rule {
    detect_label = "Pivotal Cloudfoundry - ConvergenceLRPDuration - Minor."
    severity = "Minor"
  }

  rule {
    detect_label = "Pivotal Cloudfoundry - ConvergenceLRPDuration - Critical."
    severity = "Critical"
  }
  /*
  rule {
    detect_label = "Pivotal Cloudfoundry - FetchStatesDuration > 2 sec."
    severity     = "Minor"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - FetchStatesDuration > 5 sec."
    severity     = "Critical"
  }
  rule {
    detect_label = "Pivotal Cloudfoundry - LRPAuctionsStarted Historical norm deviation."
    severity     = "Warning"
  }
 rule {
    detect_label = "Pivotal Cloudfoundry - TaskAuctionsFailed - Minor."
    severity     = "Minor"
  }
 rule {
    detect_label = "Pivotal Cloudfoundry - TaskAuctionsFailed - Critical."
    severity     = "Critical"
  }
 */
}