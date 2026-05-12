#!/bin/bash

yum update -y

yum install amazon-cloudwatch-agent -y

touch /var/log/app.log

cat <<EOF > /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/app.log",
            "log_group_name": "/app/logs",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  },

  "metrics": {
    "append_dimensions": {
      "InstanceId": "\${aws:InstanceId}"
    },

    "metrics_collected": {
      "mem": {
        "measurement": [
          "mem_used_percent"
        ],

        "metrics_collection_interval": 60
      },

      "disk": {
        "measurement": [
          "used_percent"
        ],

        "metrics_collection_interval": 60,

        "resources": [
          "*"
        ]
      }
    }
  }
}
EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json \
-s

while true
do
  echo "ERROR: simulated application failure" >> /var/log/app.log

  sleep 10
done