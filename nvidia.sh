#!/bin/bash
WEBHOOK_URL="https://open.feishu.cn/open-apis/bot/v2/hook/26c9a7df-529d-4595-81f3-ddec78a6c66b"
# Check if nvidia-smi exists
ip_address=$(hostname -I | awk '{print $1}')
if ! lspci | grep -i nvidia > /dev/null; then
    MESSAGE="机器$ip_address：Nvidia GPU not detected!"
    # Send alert message to Feishu
    curl -X POST -H 'Content-Type: application/json' -d "{\"msg_type\": \"text\",\"content\": {\"text\": \"$MESSAGE\"}}" $WEBHOOK_URL
fi
