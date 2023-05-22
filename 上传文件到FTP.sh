#!/bin/bash
upload_ip=180.76.182.254 #ftpip
port=2222 #ftp port
ftpuser=ftptest #ftpuser
ftppswd=123 #ftp_password
a=$1
s=$2
ftp_folder_path=$s  #需要判断的文件夹的绝对路径
local_dir=$a
local_record=record.log 
#定义一个连接到ftp的函数
echo FTP：$upload_ip
echo ftpuser：$ftpuser
echo FTPpasswd：$ftppswd
echo FTPpath：$ftp_folder_pathZZ
echo download_path：$local_dir
ftpCheckFile()
{
ftp -n -i $upload_ip $port <<EOF
user $ftpuser $ftppswd
cd ${ftp_folder_path}
bye
EOF
}

cat /dev/null > ${local_record}
ftpCheckFile > ${local_record}
grep -c 'Failed to change directory.' ${local_record}
if [ `grep -c 'Failed to change directory.' ${local_record}` -eq 1 ];then
  echo "目录$s 不存在，将自动创建"
ftp -n -i $upload_ip $port <<EOF
user $ftpuser $ftppswd
mkdir $s
cd $ftp_folder_path
lcd $local_dir
prompt
mput *
bye
EOF
 else
        echo 目录$s存在
ftp -v -n $upload_ip $port <<EOF
user $ftpuser $ftppswd
cd $ftp_folder_path
lcd $local_dir
prompt
mput *
bye
EOF
#here document
fi
echo "commit to ftp successfully"
