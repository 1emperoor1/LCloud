#!/usr/bin/env bash

# 1. Pobranie metadanych
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
SECURITY_GROUPS=$(curl -s http://169.254.169.254/latest/meta-data/security-groups)

# 2. Informacje o systemie
OS_INFO=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')

# 3. Lista użytkowników z powłoką bash/sh
USERS=$(awk -F: '($7 ~ /bash|sh$/) {print $1}' /etc/passwd)

# 4. Tworzenie pliku z informacjami
OUTPUT_FILE="/tmp/instance_info.txt"
{
  echo "Instance ID: $INSTANCE_ID"
  echo "Public IP: $PUBLIC_IP"
  echo "Private IP: $PRIVATE_IP"
  echo "Security Groups: $SECURITY_GROUPS"
  echo "Operating System: $OS_INFO"
  echo "Users (bash/sh): $USERS"
} > "$OUTPUT_FILE"

# 5. Wgrywanie pliku do S3
aws s3 cp "$OUTPUT_FILE" "s3://nazwa-bucketu/instance_info.txt"
