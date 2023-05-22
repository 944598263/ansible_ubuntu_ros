#!/bin/bash

# 设置飞书机器人 Webhook URL
webhook_url="https://open.feishu.cn/open-apis/bot/v2/hook/26c9a7df-529d-4595-81f3-ddec78a6c66b"

# 获取本地 IP 地址
ip_address=$(hostname -I)

# 执行命令获取当前名称为ldbot的进程数量
process_count=$(pgrep ldbot | wc -l)
process=$(pgrep ldbot)
# 如果进程数量少于6，则发送报警消息到飞书机器人
if [ $process_count -lt 7 ]; then
  # 设置富文本格式的消息内容
  alert_msg='{
    "msg_type": "post",
    "content": {
      "post": {
        "zh_cn": {
          "title": "请注意：主服务器 '$ip_address' ！ ldbot 的进程数量过少！正常为7",
          "content": [
            [
              {
                "tag": "text",
                "text": "目前进程数量："
              },
              {
                "tag": "text",
                "text": "'$process_count'",
                "color": "warning"
              }
            ]
          ]
        }
      }
    }
  }'
  # 发送警报消息到飞书机器人
  curl -X POST -H "Content-Type: application/json" -d "$alert_msg" $webhook_url
  echo "Alert message sent to Feishu Bot!"
fi
