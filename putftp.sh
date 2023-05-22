#!/bin/bash
local_dir=/media/liangdao/liang123/cexun_changchun/temp/data/submit
upload_dir=/cexun/30-LABEL_HOME/aws_backup
sss=`find $local_dir -type d -printf $upload_dir/'%P\n'| awk '{if ($0 == "")next;print "mkdir " $0}'`
aaa=`find $local_dir -type f -printf 'put %p %P \n'`
ftp -i -g -n -v 192.168.2.69 2222 << EOF
user label601 label601
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
echo "upload files to ftp successfully"
