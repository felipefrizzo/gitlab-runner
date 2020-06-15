#!/bin/bash
set -eu

cat > /etc/gitlab-runner/config.toml <<EOF
concurrent=${GITLAB_RUNNER_CONCURRENCY}
check_interval = 0

[session_server]
  session_timeout = 1800
EOF

cat > /etc/gitlab-runner/template.toml <<EOF
[[runners]]
  limit = ${GITLAB_RUNNER_LIMIT}
  [runners.docker]
    privileged = true
    disable_cache = true
  [runners.cache]
    Type = "s3"
    Shared = true
    [runners.cache.s3]
      ServerAddress = "s3.amazonaws.com"
      BucketName = "${BUCKET_NAME}"
      BucketLocation = "us-east-1"
  [runners.machine]
    IdleCount = ${GITLAB_RUNNER_IDLE_COUNT}
    IdleTime = 600
    MaxBuilds = ${GITLAB_RUNNER_MAX_BUILDS}
    OffPeakTimezone = "America/Sao_Paulo"
    OffPeakPeriods = [
      "* * 0-8,19-22 * * mon-fri *",
      "* * * * * sat,sun *"
    ]
    OffPeakIdleCount = 0
    OffPeakIdleTime = 300
    MachineDriver = "amazonec2"
    MachineName = "${GITLAB_RUNNER_MANAGER_NAME}-%s"
    MachineOptions = [
      "amazonec2-region=${AWS_DEFAULT_REGION}",
      "amazonec2-vpc-id=${AWS_VPC_ID}",
      "amazonec2-subnet-id=${AWS_SUBNET_ID}",
      "amazonec2-private-address-only=true",
      "amazonec2-use-private-address=true",
      "amazonec2-tags=runner-manager-name,${GITLAB_RUNNER_MANAGER_NAME},ManagedBy,gitlab-runner,environment,${ENVIRONMENT}",
      "amazonec2-security-group=${AWS_SECURITY_GROUP}",
      "amazonec2-instance-type=${AWS_INSTANCE_TYPE}",
      "amazonec2-request-spot-instance=${AWS_REQUEST_SPOT_INSTANCE}",
      "amazonec2-spot-price=${AWS_SPOT_PRICE}",
      "amazonec2-root-size=${ROOT_DISK_SIZE}",
    ]
EOF

sudo gitlab-runner register \
  --template-config "/etc/gitlab-runner/template.toml" \
  --non-interactive \
  --description "${GITLAB_RUNNER_NAME}" \
  --url "${GITLAB_RUNNER_URL}" \
  --executor "docker+machine" \
  --registration-token "${GITLAB_RUNNER_TOKEN}" \
  --docker-image "alpine"

sudo gitlab-runner start
echo "Finished user-data script."