resource "aws_cloudwatch_dashboard" "main_dashboard" {

  dashboard_name = "observability-dashboard"

  dashboard_body = jsonencode({

    widgets = [

      # =========================
      # CPU
      # =========================

      {
        type = "metric"

        x = 0
        y = 0

        width  = 12
        height = 6

        properties = {

          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              aws_instance.monitoring_instance.id
            ]
          ]

          period = 300

          stat = "Average"

          region = var.aws_region

          title = "EC2 CPU Utilization"
        }
      },

      # =========================
      # MEMORY
      # =========================

      {
        type = "metric"

        x = 12
        y = 0

        width  = 12
        height = 6

        properties = {

          metrics = [
            [
              "CWAgent",
              "mem_used_percent",
              "InstanceId",
              aws_instance.monitoring_instance.id
            ]
          ]

          period = 60

          stat = "Average"

          region = var.aws_region

          title = "EC2 Memory Usage"
        }
      },

      # =========================
      # DISK
      # =========================

      {
        type = "metric"

        x = 0
        y = 7

        width  = 12
        height = 6

        properties = {

          metrics = [
            [
              "CWAgent",
              "disk_used_percent",
              "InstanceId",
              aws_instance.monitoring_instance.id,
              "path",
              "/"
            ]
          ]

          period = 60

          stat = "Average"

          region = var.aws_region

          title = "EC2 Disk Usage"
        }
      },

      # =========================
      # APPLICATION ERRORS
      # =========================

      {
        type = "metric"

        x = 12
        y = 7

        width  = 12
        height = 6

        properties = {

          metrics = [
            [
              "AppMetrics",
              "ErrorCount"
            ]
          ]

          period = 60

          stat = "Sum"

          region = var.aws_region

          title = "Application Errors"
        }
      }
    ]
  })
}