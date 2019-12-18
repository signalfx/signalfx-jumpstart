resource "signalfx_dashboard" "hostbasedmodel0" {
  name            = "Host Based Model"
  dashboard_group = signalfx_dashboard_group.usageoverview0.id

  time_range = "-1w"

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
    chart_id = signalfx_single_value_chart.hiresmetrics0.id
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
    chart_id = signalfx_time_chart.hiresmetrictrend0.id
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
    chart_id = signalfx_text_chart.hiresmetricinfo0.id
    width    = 3
    height   = 1
    row      = 4
    column   = 9
  }
}