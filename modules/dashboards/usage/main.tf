resource "signalfx_dashboard_group" "usageoverview" {
  name        = "${var.sfx_prefix} Usage Overview (Terraform)"
  description = "Host Based Model, MTS and Events Usage"
}
