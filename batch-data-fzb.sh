#!/bin/bash
# Trip名称
trip=20230401_175906_884
# Trip存放路径
dir=/media/liangdao/liang123/ouye/20230401_175906_884
# 切包数据存放目录，根据项目替换
spilt_dir=/media/liangdao/liang123/ouye/spilt
# 处理工具路径
tools_work_dir=/media/liangdao/liang123/software/tools4ouye/toolchain_compass2022_onlyInnovizOne
# 切包工具路径
spilt_work_dir=/media/liangdao/liang123/software/tools4zhulu/scene_export  
# mode定义
mode=no_algo
# compass工作路径
app_path=/media/liangdao/liang123/software/tools4ouye/ouye_delivery_0.1/compass_alt20_oy_cp_cn_0.4/
# compass源数据路径,默认为spilt处理后的数据
bag_path=$spilt_dir/$trip/spiltall
# compass处理后存放路径
output_path=/media/liangdao/liang123/ouye/ALT
# 进入切包虚环境地址
. /home/liangdao/anaconda3/bin/activate venv3.9
conda activate venv3.9

WEBHOOK_URL="https://open.feishu.cn/open-apis/bot/v2/hook/26c9a7df-529d-4595-81f3-ddec78a6c66b"
ip_address=$(hostname -I | awk '{print $1}')

############################## start can_sync task #####################################################
analysis() {
  n1=$(du -m $dir/can | awk '{print $1}')
  n2=$(du -m $dir/can1 | awk '{print $1}')

  if [ $n2 -gt $n1 ];then
    cd $dir &&  rm -rf can/*.yaml && rm -rf can1/*.yaml && rm -rf can2/*.yaml && cd $tools_work_dir && nohup ./toolchain_compass2022 --mode $mode $dir > $trip.log &
    MESSAGE="data processing $ip_address $trip : Start $mode task \nPlease check in $tools_work_dir/$trip.log"
    curl -X POST -H 'Content-Type: application/json' -d "{\"msg_type\": \"text\",\"content\": {\"text\": \"$MESSAGE\"}}" $WEBHOOK_URL
    sleep 5 
    if grep -q "Error" "$tools_work_dir/$trip.log"; then
      MESSAGE=" $ip_address $trip : no_algo Error !!! \nPlease check in $tools_work_dir/$trip.log"
      curl -X POST -H 'Content-Type: application/json' -d "{\"msg_type\": \"text\",\"content\": {\"text\": \"$MESSAGE\"}}" $WEBHOOK_URL
    fi
  else
    cd $dir &&  mv can can3 && mv can1 can && mv can3 can1 &&  rm -rf can/*.yaml && rm -rf can1/*.yaml && rm -rf can2/*.yaml && cd $tools_work_dir && nohup ./toolchain_compass2022 --mode $mode $dir > $trip.log &
    MESSAGE="data processing $ip_address $trip: no_algo Start packet cutting task \nPlease check in $tools_work_dir/$trip.log"
    curl -X POST -H 'Content-Type: application/json' -d "{\"msg_type\": \"text\",\"content\": {\"text\": \"$MESSAGE\"}}" $WEBHOOK_URL
    sleep 5
    if grep -q "Error" "$tools_work_dir/$trip.log"; then
     MESSAGE=" $ip_address $trip : no_algo Error !!! \nPlease check  in $tools_work_dir/$trip.log"
     curl -X POST -H 'Content-Type: application/json' -d "{\"msg_type\": \"text\",\"content\": {\"text\": \"$MESSAGE\"}}" $WEBHOOK_URL
    fi
  fi
}
############################# start spilt task  #####################################################
spilt() {
  . /home/liangdao/anaconda3/bin/activate venv3.9
  log=$trip.log
  while true; do
    if grep -q "signal_shutdown" "$tools_work_dir/$log"; then
      num1=$(ls "$dir"/ouster/*.bag | wc -l)
      num2=$(ls "$dir"/sync/*.bag | wc -l)
      if [ "$num1" -eq "$num2" ]; then
        MESSAGE="data processing $ip_address  $trip ：no_algo done!!! \nStart packet cutting task \nPlease check in $spilt_work_dir/$log"
        curl -X POST -H 'Content-Type: application/json' -d "{\"msg_type\": \"text\",\"content\": {\"text\": \"$MESSAGE\"}}" $WEBHOOK_URL
        mkdir -p $spilt_dir/$trip
        out_dir=`cd $spilt_dir/$trip && pwd`
        cd $spilt_work_dir  && python TaggingToolJson2Csv.py --json_path $dir/tagging/*.json --output_dir $dir/ >/dev/null
        csv=`ls $dir/*.csv`
        grep -v ",,,," $csv | sed '/^\s*$/d' > $dir/1.csv && cd $spilt_work_dir  && nohup python -u innovize_excel_export_point-changjing.py -f $dir/1.csv -i $dir -o $out_dir > $log 2>&1 &
	wait
	x=0
	dir_count=`cd $spilt_dir/$trip/ && ls -l | grep "^d" | wc -l`
	while [ $x -lt $dir_count ]
        do
	mkdir -p $spilt_dir/$trip/spiltall && cp $spilt_dir/$trip/scene_$x/sync/*.bag $spilt_dir/$trip/spiltall
	x=$(( $x + 1 ))
        done
        break
      else
        echo "\e[31m error: The number of bag packages in the sync directory does not match the number in the ouster directory! \e[0m"
      fi
    fi
    sleep 10 
  done
}
############################# start ALT task  #####################################################
send_message() {
    MESSAGE=$1
    curl -X POST -H 'Content-Type: application/json' -d "{\"msg_type\": \"text\",\"content\": {\"text\": \"$MESSAGE\"}}" $WEBHOOK_URL
}
alt() {
    spilt_log="$spilt_work_dir/$log"
    if grep -q "scene split is ok" "$spilt_log"; then
        MESSAGE="data processing $ip_address  $trip ：split done!!! \nALT identification started. \nPlease check the log: \n$output_path/$trip/od.log\n$output_path/$trip/lane.log"
        send_message "$MESSAGE"
        for i in "$bag_path"/*; do
            if [ -f "$i" ]; then
                mkdir -p "$output_path/$trip"
                outdir="${output_path}/${trip}"
		            wait
		            echo "$i" && cd "$app_path" && ./compass_app -d "$i" "$outdir" > "$output_path/$trip/od.log"   #目标检测(通用场景/高速场)
                echo "$i" && cd "$app_path" && ./compass_app -l "$i" "$outdir" > "$output_path/$trip/lane.log"   #车道线&道路边缘检测 
                break
            fi
        done
    fi
}
###################################################################################################
analysis
spilt
alt


wait
MESSAGE=" all task done !!! \nanalysis dir: $dir/sync \nspilt dir：$out_dir \nalt dir: $outdir "
send_message "$MESSAGE"