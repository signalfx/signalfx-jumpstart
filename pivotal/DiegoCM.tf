resource "signalfx_detector" "pivotal_cloudfoundry_DCM_errors" {
  name         = "[SFx] Pivotal cloudFoundry Diego Ceel Metrics errors"
  description  = "Alerts for various Pivotal CloudFoundry Log related error scenarios"
  program_text = <<-EOF


from signalfx.detectors.against_periods import against_periods
from signalfx.detectors.against_recent import against_recent
from signalfx.detectors.not_reporting import not_reporting

CapacityRemainingMemory = data('bbs.rep.CapacityRemainingMemory', filter=filter('metric_source', 'cloudfoundry')).mean(over='1h').publish(label='CapacityRemainingMemory', enable=False)
not_reporting.detector(stream=CapacityRemainingMemory, resource_identifier=None, duration='15m').publish('Pivotal Cloudfoundry - CapacityRemainingMemory not being reported.')
    EOF
  rule {
    detect_label = "Pivotal Cloudfoundry - CapacityRemainingMemory not being reported."
    severity     = "Minor"
  }
 
}