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
LRPsExtra = data('bbs.LRPsExtra', filter=filter('metric_source', 'cloudfoundry')).mean_plus_stddev(stddevs=1, over='5m').publish(label='LRPsExtra', enable=True)
RequestLatency = data('bbs.RequestLatency', filter=filter('metric_source', 'cloudfoundry')).mean(over='15m').publish(label='RequestLatency', enable=False)
LRPsMissing = data('bbs.LRPsMissing', filter=filter('metric_source', 'cloudfoundry')).mean(over='5m').publish(label='LRPsMissing', enable=False)
CrashedActualLRPs = data('bbs.CrashedActualLRPs', filter=filter('metric_source', 'cloudfoundry')).mean(over='5m').publish(label='CrashedActualLRPs', enable=True)
LRPsRunning = data('bbs.LRPsRunning', filter=filter('metric_source', 'cloudfoundry')).mean(over='1h').publish(label='LRPsRunning', enable=True)

detect((when((ConvergenceLRPDuration >= 10) and (ConvergenceLRPDuration < 20)))).publish('Pivotal Cloudfoundry - ConvergenceLRPDuration - Minor.')
detect(when(ConvergenceLRPDuration >= 20 )).publish('Pivotal Cloudfoundry - ConvergenceLRPDuration - Critical.')
detect(when((LRPsExtra >= 5) and (LRPsExtra < 10))).publish('Pivotal Cloudfoundry - Diego has more LRPs running than expected Minor.')
detect(when(LRPsExtra >= 10)).publish('Pivotal Cloudfoundry - Diego has more LRPs running than expected Critical.')
not_reporting.detector(stream=cf_apps, resource_identifier=None, duration='5m').publish('Pivotal Cloudfoundry - The signal bbs.Domain.cf-apps has not reported for 5m.')
detect(when((RequestLatency >= 5) and (RequestLatency <= 10))).publish('Pivotal Cloudfoundry - The value of bbs.RequestLatency - Mean(15m) is within 5 and 10.')
detect(when(RequestLatency >= 10)).publish('Pivotal Cloudfoundry - The value of bbs.RequestLatency - Mean(15m) is greater or equal to 10.')
detect(when((LRPsMissing >= 5) and (LRPsMissing < 10))).publish('Pivotal Cloudfoundry - The value of bbs.LRPsMissing - Mean(5m) is within 5 and 10.')
detect(when(LRPsMissing >=10)).publish('Pivotal Cloudfoundry - The value of bbs.LRPsMissing - Mean(5m) is greater or equal to 10.')
detect(when((CrashedActualLRPs >= 5) and (CrashedActualLRPs < 10))).publish('Pivotal Cloudfoundry - The value of bbs.CrashedActualLRPs - Mean(5m) is within 5 and 10.')
detect(when(CrashedActualLRPs >= 10)).publish('Pivotal Cloudfoundry - The value of bbs.CrashedActualLRPs - Mean(5m) is greater or equal to 10.')
against_recent.detector_mean_std(stream=LRPsRunning, current_window='1h', historical_window='2h', fire_num_stddev=3, clear_num_stddev=2.5, orientation='out_of_band', ignore_extremes=True, calculation_mode='vanilla').publish('Pivotal Cloudfoundry - LRPsRunning - Mean(1h) in the last 1h are more than 3 standard deviation(s) above or below the mean of its preceding 1h.')
against_recent.detector_mean_std(stream=LRPsRunning, current_window='1h', historical_window='2h', fire_num_stddev=6, clear_num_stddev=2.5, orientation='out_of_band', ignore_extremes=True, calculation_mode='vanilla').publish('Pivotal Cloudfoundry - LRPsRunning - Mean(1h) in the last 1h are more than 6 standard deviation(s) above or below the mean of its preceding 1h.')

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

 rule {
    detect_label = "Pivotal Cloudfoundry - The value of bbs.LRPsMissing - Mean(5m) is within 5 and 10."
    severity     = "Minor"
  }

  rule {
    detect_label = "Pivotal Cloudfoundry - The value of bbs.LRPsMissing - Mean(5m) is greater or equal to 10."
    severity     = "Minor"
  }

 rule {
    detect_label = "Pivotal Cloudfoundry - The value of bbs.CrashedActualLRPs - Mean(5m) is within 5 and 10."
    severity     = "Minor"
  }

  rule {
    detect_label = "Pivotal Cloudfoundry - The value of bbs.CrashedActualLRPs - Mean(5m) is greater or equal to 10."
    severity     = "Critical"
  }

rule {
    detect_label = "Pivotal Cloudfoundry - LRPsRunning - Mean(1h) in the last 1h are more than 3 standard deviation(s) above or below the mean of its preceding 1h."
    severity     = "Minor"
  }

rule {
    detect_label = "Pivotal Cloudfoundry - LRPsRunning - Mean(1h) in the last 1h are more than 6 standard deviation(s) above or below the mean of its preceding 1h."
    severity     = "Critical"
  }
}