resource "signalfx_text_chart" "title0" {
  name     = " "
  markdown = <<-EOF
    <table width="100%" rules="none">
    <tbody><tr>
    <td align="left" bgcolor="#0064b7" height="80px">
    <font size="5" color="#ffffff">Host Based Model Count</font>
    </td>
    </tr>
    <tr>
    <td align="left" bgcolor="#0091ea" height="40px">
    <font size="3" color="#ffffff">Metrics about the volume and nature of data that SignalFx is processing and storing for you, such as the number of hosts, containers, custom metrics and hi-res metrics in the last 10 minutes.</font>
    </td>
    </tr>
    </tbody></table>
  EOF
}
resource "signalfx_single_value_chart" "hostcount0" {
  name = "Host Count"
  description = "Number of Hosts SignalFx has seen in last 10 minutes"
  program_text = <<-EOF
    data('sf.org.numResourcesMonitored', filter=filter('resourceType', 'host')).publish(label='A')
  EOF
  viz_options {
    label        = "A"
    color        = "blue"
    value_suffix = " Hosts"
  }
  max_precision = 3
}

resource "signalfx_time_chart" "hosttrend0" {
  name         = "Hosts Count - Trend"
  description  = "Host count (blue), % week-on-week growth (brown)"
  program_text = <<-EOF
    A = data('sf.org.numResourcesMonitored', filter=filter('resourceType', 'host')).publish(label='A')
    B = (A).timeshift('1w').publish(label='B', enable=False)
    C = ((A-B)/B).scale(100).publish(label='C')
  EOF
  time_range = 604800
  plot_type = "LineChart"
  axis_left {
    label = "Hosts"
  }
  axis_right {
    label = "WoW Growth (%)"
  }
  viz_options {
    label = "A"
    color = "blue"
    value_suffix = " Hosts"
  }
  viz_options {
    label = "C"
    color = "brown"
    axis = "right"
  }
}

resource "signalfx_text_chart" "hostinfo0" {
  name = "Host - Info"
  markdown = <<-EOF
    The chart above shows Host count.

    Metric(s):
    <code>sf.org.numResourcesMonitored</code>

    Filter(s):
    <code>resourceType:host</code>

    Number of Hosts being monitored in your organization.
  EOF
}
resource "signalfx_single_value_chart" "containercount0" {
  name         = "Container Count"
  description  = "Number of Containers SignalFx has seen in last 10 minutes"
  program_text = <<-EOF
    data('sf.org.numResourcesMonitored', filter=filter('resourceType', 'container')).publish(label='A')
  EOF
  viz_options {
    label = "A"
    color = "blue"
    value_suffix = " Containers"
  }
  max_precision = 3
}

resource "signalfx_time_chart" "containertrend0" {
  name = "Containers Count - Trend"
  description = "Container count (blue), % week-on-week growth (brown)"
  program_text = <<-EOF
    A = data('sf.org.numResourcesMonitored', filter=filter('resourceType', 'container')).mean(over='10m').publish(label='A')
    B = (A).timeshift('1w').publish(label='B', enable=False)
    C = ((A-B)/B).scale(100).publish(label='C')
  EOF
  time_range = 604800
  plot_type  = "LineChart"
  axis_left {
    label = "Containers"
  }
  axis_right {
    label = "WoW Growth (%)"
  }
  viz_options {
    label        = "A"
    color        = "blue"
    value_suffix = " Containers"
  }
  viz_options {
    label = "C"
    color = "brown"
    axis  = "right"
  }
}
resource "signalfx_text_chart" "containerinfo0" {
  name     = "Container - Info"
  markdown = <<-EOF
    The chart above shows Container count.

    Metric(s):
    <code>cpu.usage.total</code>

    Number of Containers being monitored in your organization.
  EOF
}

resource "signalfx_single_value_chart" "custommetrics0" {
  name = "Custom Metrics"
  description = "Number of Custom Metrics SignalFx has seen in last 10 minutes"
  program_text = <<-EOF
    data('sf.org.numCustomMetrics').publish(label='A')
  EOF
  viz_options {
    label        = "A"
    color        = "blue"
    value_suffix = " Custom Metrics"
  }
  max_precision = 3
}

resource "signalfx_time_chart" "custommetrictrend0" {
  name         = "Custom Metrics - Trend"
  description  = "Custom Metrics (blue), % week-on-week growth (brown)"
  program_text = <<-EOF
    A = data('sf.org.numCustomMetrics').mean(over='10m').publish(label='A')
    B = (A).timeshift('1w').publish(label='B', enable=False)
    C = ((A-B)/B).scale(100).publish(label='C')
  EOF
  time_range = 604800
  plot_type = "LineChart"
  axis_left {
    label = "Custom Metrics"
  }
  axis_right {
    label = "WoW Growth (%)"
  }
  viz_options {
    label = "A"
    color = "blue"
    value_suffix = " Custom Metrics"
  }
  viz_options {
    label = "C"
    color = "brown"
    axis = "right"
  }
}
resource "signalfx_text_chart" "custommetricinfo0" {
  name = "Custom Metric - Info"
  markdown = <<-EOF
    The chart above shows Custom Metric count.

    Metric(s):
    <code>sf.org.numCustomMetrics</code>

    Number of Custom Metrics being monitored in your organization.
  EOF
}
resource "signalfx_single_value_chart" "hiresmetrics0" {
  name         = "Hi-Res Metrics"
  description  = "Number of Hi-Res Metrics SignalFx has seen in last 10 minutes"
  program_text = <<-EOF
    data('sf.org.numHighResolutionMetrics').publish(label='A')
  EOF
  viz_options {
    label = "A"
    color = "blue"
    value_suffix = " Hi-Res Metrics"
  }
  max_precision = 3
}

resource "signalfx_time_chart" "hiresmetrictrend0" {
  name = "Hi-Res Metrics - Trend"
  description = "Hi-Res Metrics (blue), % week-on-week growth (brown)"
  program_text = <<-EOF
    A = data('sf.org.numHighResolutionMetrics').mean(over='10m').publish(label='A')
    B = (A).timeshift('1w').publish(label='B', enable=False)
    C = ((A-B)/B).scale(100).publish(label='C')
  EOF
  time_range = 604800
  plot_type  = "LineChart"
  axis_left {
    label = "Hi-Res Metrics"
  }
  axis_right {
    label = "WoW Growth (%)"
  }
  viz_options {
    label        = "A"
    color        = "blue"
    value_suffix = " Hi-Res Metrics"
  }
  viz_options {
    label = "C"
    color = "brown"
    axis  = "right"
  }
}
resource "signalfx_text_chart" "hiresmetricinfo0" {
  name     = "Hi-Res Metric - Info"
  markdown = <<-EOF
    The chart above shows Hi-Res Metrics count.

    Metric(s):
    <code>sf.org.numHighResolutionMetrics</code>

    Number of Hi-Res Metrics being monitored in your organization.
  EOF
}