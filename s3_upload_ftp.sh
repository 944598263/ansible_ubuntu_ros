#!/bin/bash
######################################################################################################################################
#	script description:	Download files from S3 to local and uploading from local to FTP
#
#	editor:			fengzhenbo   2023-2-3
#
#	use command:		sh down-s3-2-ftp.sh s3_path  ftp_path ftp_user ftp_passwd  (The following is an example)
# 
#sh s3_upload_ftp.sh s3://liangdao-germany-data-exchange-bucket/zhu_lu/zhulu_china/train_data/submit/20221112/ /shangqj/30-LABEL_HOME/test label801 label801
#
######################################################################################################################################
local_dir=/media/liangdao/liang123/back/ #local path, modifiable
upload_dir=$2
rm -rf 2.log
rm -rf $local_dir/* 			#Each execution will delete all files in the directory
aws s3 ls $1 --summarize --recursive  --human-readable >2.log
num=`tac 2.log |sed -n 2p | awk '{print $3}'`
size=`tac 2.log |sed -n 1p | awk '{print $3$4 }'`
echo "\033[31m 共$num条数据，总大小：$size \033[0m"
echo "\033[33m ******Start downloading files from S3 to local***\033[0m"
aws s3 cp $1 $local_dir --recursive > /dev/null
echo "\033[32m ******Download files from S3 to local completion** \033[0m"
#upload2ftp
sss=`find $local_dir -type d -printf $upload_dir/'%P\n'| awk '{if ($0 == "")next;print "mkdir " $0}'`
aaa=`find $local_dir -type f -printf 'put %p %P \n'`
echo "\033[33m ******Start uploading from local to FTP********* \033[0m"
ftp -i -g -n -v 192.168.2.69 2222 << EOF > /dev/null
user $3 $4
type binary
hash
prompt
lcd $local_dir
$sss 
cd $upload_dir
$aaa 
bye
#here document
EOF
echo "\033[32m ************upload files to ftp successfully***** \033[0m"

