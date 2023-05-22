#!/bin/bash

# 采集一个函数
rosbagDir() {
  # 获取传入的目录路径
  local dir=$1
  # 循环指定目录下的所有文件
  local files
  #files=$(ls "$dir" |grep "\.doc$")
  files=$(ls "$dir" )
  for file in $files; do
    local path="$dir/$file" #指的是当前遍历文件的完整路径
    # 判断是否是目录，如果是目录则递归遍历，如果是文件则执行rosbag info
    if [ -d "$path" ]; then
      rosbagDir "$path"
    else
      echo "$path"
      rosbag info $path
    fi
  done
}

# 调用函数，传入顶级目录为/root
rosbagDir $1

