#!/bin/bash

set -x
exec > >(tee /var/log/user-data.log | logger -t user-data) 2>&1

echo "**********************************"
echo "*** Starting user-data install ***"
echo "**********************************"

# set variables from AWS
echo "Setting variables from AWS"
curl -s http://169.254.169.254/latest/dynamic/instance-identity/document >metadata.json
export AWS_INSTANCE_ID=$(grep -oP '(?<="instanceId" : ")[^"]*(?=")' metadata.json)


### install monitoring configuration
echo "Configuring cloudwatch agent /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json"
cat <<EOF >/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
	"agent": {
		"metrics_collection_interval": 10,
		"run_as_user": "root"
	},
	"logs": {
		"logs_collected": {
			"files": {
				"collect_list": [
					{
						"file_path": "/var/log/messages",
						"log_group_name": "/aws/services/go-app",
						"log_stream_name": "$AWS_INSTANCE_ID/log-messages"
					},
                    {
						"file_path": "/var/log/user-data.log",
						"log_group_name": "/aws/services/go-app",
						"log_stream_name": "$AWS_INSTANCE_ID/user-data"
					}
				]
			}
		}
	}
}
EOF

# ensure cloudwatch is enabled and restarted
systemctl enable amazon-cloudwatch-agent
systemctl restart amazon-cloudwatch-agent

systemctl daemon-reload
systemctl restart docker.service

sudo tee /opt/docker-compose/docker-compose.yml <<- "EOF"
version: '3.7'
services:
  web:
    image: nginx
	ports:
	  - "8080:80"	
    environment:  # Environment variables
      - LOG_LEVEL=info
	  - NGINX_PORT=80
    logging:
      driver: awslogs
      options:
        awslogs-region: eu-west-1
        awslogs-group: /aws/services/go-app
        awslogs-stream: docker-logs/go-app
EOF

## Docker compose up
docker-compose -f /opt/docker-compose/docker-compose.yml --compatibility up -d \
  && log 'info' 'Docker compose started' \
  || log 'error' 'Failed to start docker compose';

log 'success' 'Bootstrapping complete.';