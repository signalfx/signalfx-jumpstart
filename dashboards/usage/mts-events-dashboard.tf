resource "signalfx_dashboard" "mtsevents0" {
  name            = "MTS & Event Usage"
  dashboard_group = signalfx_dashboard_group.usageoverview0.id

  time_range = "-1w"

  chart {
    chart_id = signalfx_text_chart.title1.id
    width    = 12
    height   = 1
    row      = 1
    column   = 0
  }

  chart {
    chart_id = signalfx_single_value_chart.mtscreationrate0.id
    width    = 4
    height   = 1
    row      = 2
    column   = 0
  }
  chart {
    chart_id = signalfx_single_value_chart.epm0.id
    width    = 4
    height   = 1
    row      = 2
    column   = 4
  }
  chart {
    chart_id = signalfx_single_value_chart.etscreationrate0.id
    width    = 4
    height   = 1
    row      = 2
    column   = 8
  }

  chart {
    chart_id = signalfx_time_chart.mtstrend0.id
    width    = 4
    height   = 1
    row      = 3
    column   = 0
  }
  chart {
    chart_id = signalfx_time_chart.epmtrend0.id
    width    = 4
    height   = 1
    row      = 3
    column   = 4
  }
  chart {
    chart_id = signalfx_time_chart.etstrend0.id
    width    = 4
    height   = 1
    row      = 3
    column   = 8
  }

  chart {
    chart_id = signalfx_text_chart.mtsinfo0.id
    width    = 4
    height   = 1
    row      = 4
    column   = 0
  }
  chart {
    chart_id = signalfx_text_chart.epminfo0.id
    width    = 4
    height   = 1
    row      = 4
    column   = 4
  }
  chart {
    chart_id = signalfx_text_chart.etsinfo0.id
    width    = 4
    height   = 1
    row      = 4
    column   = 8
  }
}