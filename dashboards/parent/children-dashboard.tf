resource "signalfx_dashboard" "childrenusage0" {
  name            = "Parent/Child Usage"
  dashboard_group = signalfx_dashboard_group.parentchildoverview0.id
  time_range      = "-1w"
  variable {
    alias                  = "Child Org"
    apply_if_exist         = false
    description            = "Child Org"
    property               = "childOrgName"
    replace_only           = false
    restricted_suggestions = false
    value_required         = false
    values = [
      "Choose Child Org",
    ]
    values_suggested = []
  }

  chart {
    chart_id = signalfx_text_chart.title0.id
    width    = 12
    height   = 1
    row      = 1
    column   = 0
  }
  chart {
    chart_id = signalfx_single_value_chart.hostcount0.id
    width    = 3
    height   = 1
    row      = 2
    column   = 0
  }
  chart {
    chart_id = signalfx_single_value_chart.containercount0.id
    width    = 3
    height   = 1
    row      = 2
    column   = 3
  }
  chart {
    chart_id = signalfx_single_value_chart.custommetrics0.id
    width    = 3
    height   = 1
    row      = 2
    column   = 6
  }
  chart {
    chart_id = signalfx_single_value_chart.detectors0.id
    width    = 3
    height   = 1
    row      = 2
    column   = 9
  }
  chart {
    chart_id = signalfx_time_chart.hosttrend0.id
    width    = 3
    height   = 1
    row      = 3
    column   = 0
  }
  chart {
    chart_id = signalfx_time_chart.containertrend0.id
    width    = 3
    height   = 1
    row      = 3
    column   = 3
  }
  chart {
    chart_id = signalfx_time_chart.custommetrictrend0.id
    width    = 3
    height   = 1
    row      = 3
    column   = 6
  }
  chart {
    chart_id = signalfx_time_chart.detectortrend0.id
    width    = 3
    height   = 1
    row      = 3
    column   = 9
  }

  chart {
    chart_id = signalfx_text_chart.hostinfo0.id
    width    = 3
    height   = 1
    row      = 4
    column   = 0
  }
  chart {
    chart_id = signalfx_text_chart.containerinfo0.id
    width    = 3
    height   = 1
    row      = 4
    column   = 3
  }
  chart {
    chart_id = signalfx_text_chart.custommetricinfo0.id
    width    = 3
    height   = 1
    row      = 4
    column   = 6
  }
  chart {
    chart_id = signalfx_text_chart.detectorinfo0.id
    width    = 3
    height   = 1
    row      = 4
    column   = 9
  }
}