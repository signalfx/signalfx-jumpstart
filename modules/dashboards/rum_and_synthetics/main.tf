resource "signalfx_dashboard_group" "rumandsynthetics" {
  name        = "${var.sfx_prefix} RUM and Synthetics (Terraform)"
  description = "RUM and SYnthetics Dashboard"
}
