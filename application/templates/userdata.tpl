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

### Installing Docker
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker

yum install -y yum-utils
curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m) -o /bin/docker-compose
chmod +x /bin/docker-compose
sudo usermod -aG docker $USER

systemctl daemon-reload
systemctl restart docker.service


aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 009215683468.dkr.ecr.eu-west-1.amazonaws.com

mkdir /opt/docker-compose

sudo tee /opt/docker-compose/docker-compose.yml <<- "EOF"
version: '3.7'
services:
  go_app:
    image: 009215683468.dkr.ecr.eu-west-1.amazonaws.com/go-web-api:1041f82135a64fff77352ea3d1cd8b7392dfe284
    ports:
      - "80:80"
    environment:  # Environment variables
      - LOG_LEVEL=info
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