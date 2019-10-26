resource "signalfx_detector" "pivotal_cloudfoundry_diego_errors" {
  name         = "[SFx] Pivotal cloudFoundry diego errors"
  description  = "Alerts for various Pivotal CloudFoundry Diego related error scenarios"
  program_text = <<-EOF


from signalfx.detectors.against_periods import against_periods
from signalfx.detectors.against_recent import against_recent
from signalfx.detectors.not_reporting import not_reporting

A = data('bbs.ConvergenceLRPDuration', filter=filter('metric_source', 'cloudfoundry'), rollup='max').max(over='15m').publish(label='A')
ConvergenceLRPDuration= (A/1000000000).publish(label='ConvergenceLRPDuration')
cf_apps = data('bbs.Domain.cf-apps', filter=filter('metric_source', 'cloudfoundry')).publish(label='cf_apps')
LRPsExtra = data('bbs.LRPsExtra', filter=filter('metric_source', 'cloudfoundry')).mean_plus_stddev(stddevs=1, over='5m').publish(label='LRPsExtra', enable=False)
RequestLatency = data('bbs.RequestLatency', filter=filter('metric_source', 'cloudfoundry')).mean(over='15m').publish(label='RequestLatency', enable=False)

detect((when((ConvergenceLRPDuration >= 10) and (ConvergenceLRPDuration < 20)))).publish('Pivotal Cloudfoundry - ConvergenceLRPDuration - Minor.')
detect(when(ConvergenceLRPDuration >= 20 )).publish('Pivotal Cloudfoundry - ConvergenceLRPDuration - Critical.')
detect(when((LRPsExtra >= 5) and (LRPsExtra < 10))).publish('Pivotal Cloudfoundry - Diego has more LRPs running than expected Minor.')
detect(when(LRPsExtra >= 10)).publish('Pivotal Cloudfoundry - Diego has more LRPs running than expected Critical.')
not_reporting.detector(stream=cf_apps, resource_identifier=None, duration='5m').publish('Pivotal Cloudfoundry - The signal bbs.Domain.cf-apps has not reported for 5m.')
detect(when((RequestLatency >= 5) and (RequestLatency <= 10))).publish('Pivotal Cloudfoundry - The value of bbs.RequestLatency - Mean(15m) is within 5 and 10.')
detect(when(RequestLatency >= 10)).publish('Pivotal Cloudfoundry - The value of bbs.RequestLatency - Mean(15m) is greater or equal to 10.')

    EOF
  rule {
    detect_label = "Pivotal Cloudfoundry - ConvergenceLRPDuration - Minor."
    severity     = "Minor"
  }

  rule {
    detect_label = "Pivotal Cloudfoundry - ConvergenceLRPDuration - Critical."
    severity     = "Critical"
  }

  rule {
    detect_label = "Pivotal Cloudfoundry - Diego has more LRPs running than expected Minor."
    severity     = "Minor"
  }

  rule {
    detect_label = "Pivotal Cloudfoundry - Diego has more LRPs running than expected Critical."
    severity     = "Minor"
  }
  
  rule {
    detect_label = "Pivotal Cloudfoundry - The signal bbs.Domain.cf-apps has not reported for 5m."
    severity     = "Critical"
  }
  
  rule {
    detect_label = "Pivotal Cloudfoundry - The value of bbs.RequestLatency - Mean(15m) is within 5 and 10."
    severity     = "Minor"
  }
 rule {
    detect_label = "Pivotal Cloudfoundry - The value of bbs.RequestLatency - Mean(15m) is greater or equal to 10."
    severity     = "Critical"
  }
  /*
 rule {
    detect_label = "Pivotal Cloudfoundry - TaskAuctionsFailed - Critical."
    severity     = "Critical"
  }
 */
}