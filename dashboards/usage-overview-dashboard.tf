resource "signalfx_dashboard_group" "usageoverview0" {
    name = "Usage Overview (Terraform)"
    description = "Host Based Model, MTS and Events Usage"
}

resource "signalfx_dashboard" "hostbasedmodel0" {
    name = "Host Based Model"
    dashboard_group = "${signalfx_dashboard_group.usageoverview0.id}"

    time_range = "-1w"

    chart {
        chart_id = "${signalfx_single_value_chart.hostcount0.id}"
        width = 3
        height = 1
        row = 1
    }
    chart {
        chart_id = "${signalfx_single_value_chart.containercount0.id}"
        width = 3
        height = 1
        row = 1
        column = 3
    }
    chart {
        chart_id = "${signalfx_single_value_chart.custommetrics0.id}"
        width = 3
        height = 1
        row = 1
        column = 6
    }    
    chart {
        chart_id = "${signalfx_single_value_chart.hiresmetrics0.id}"
        width = 3
        height = 1
        row = 1
        column = 9
    }    
}

resource "signalfx_single_value_chart" "hostcount0" {
    name = "Host Count"
    description = "Number of Hosts SignalFx has seen in last 10 minutes"
    program_text = <<-EOF
        data('sf.org.numResourcesMonitored', filter=filter('resourceType', 'host')).publish(label='A')
        EOF

    viz_options {
        label = "A"
        color = "blue"
        value_suffix = " Hosts"
    } 
}

resource "signalfx_single_value_chart" "containercount0" {
    name = "Container Count"
    description = "Number of Containers SignalFx has seen in last 10 minutes"
    program_text = <<-EOF
        data('sf.org.numResourcesMonitored', filter=filter('resourceType', 'container')).publish(label='A')
        EOF

    viz_options {
        label = "A"
        color = "blue"
        value_suffix = " Containers"
    } 
}

resource "signalfx_single_value_chart" "custommetrics0" {
    name = "Custom Metrics"
    description = "Number of Custom Metrics SignalFx has seen in last 10 minutes"
    program_text = <<-EOF
        data('sf.org.numCustomMetrics').publish(label='A')
        EOF

    viz_options {
        label = "A"
        color = "blue"
        value_suffix = " Custom Metrics"
    } 
}

resource "signalfx_single_value_chart" "hiresmetrics0" {
    name = "Hi-Res Metrics"
    description = "Number of Hi-Res Metrics SignalFx has seen in last 10 minutes"
    program_text = <<-EOF
        data('sf.org.numHighResolutionMetrics').publish(label='A')
        EOF

    viz_options {
        label = "A"
        color = "blue"
        value_suffix = " Hi-Res Metrics"
    } 
}