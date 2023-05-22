#!/bin/bash
######################################################################################################################################
#	script description:	Download files from ftp to local and uploading from local to S3
#
#	editor:			fengzhenbo   2023-2-3
#
#	use command:		sh  ftp_upload_s3.sh ftp_path ftp_user ftp_passwd s3_path (The following is an example)
# 
#sh ftp_upload_s3.sh /shangqj/30-LABEL_HOME/test label801 label801 s3://liangdao-germany-data-exchange-bucket/SSJ/test/
#
######################################################################################################################################
local_dir=/media/liangdao/liang123/back/ #local path, modifiable
upload_dir=$1
  rm -rf 1.log
  rm -rf $local_dir/* 			#Each execution will delete all files in the directory
  echo "\033[33m ******Start downloading files from ftp to local********* \033[0m"
	  cd $local_dir
	  wget -q -nH -r -N -l inf -np --cut-dirs=3 --ftp-user=$2 --ftp-password=$3 ftp://192.168.2.69:2222$1
	  size=`du -sh /media/liangdao/liang123/back/|awk '{print $1}'`
  echo "\033[32m ************Download files from ftp to local completion！SIZE:$size***** \033[0m"
  echo "\033[33m ******Start uploading from local to S3***\033[0m"
  	 aws s3 cp $local_dir $4 --recursive >1.log
  echo "\033[32m ************upload files to S3 successfully***** \033[0m"
