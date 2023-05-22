#/bin/sh
#根据每天的trip数量来决定是否放开通过文件名进行传参设置,sh batch_copy.sh 20221019_113915_222_new
#source_path=/media/liangdao/liang123/zhulu/scene_split/excel_export_scene_package_zhulu_20221019/20221019_113915_222_new
source_path=/media/liangdao/liang123/zhulu/seg/20221114/scene_0/$1
des_path=/media/liangdao/liang123/zhulu/cut_frame_result
dir_count=`cd $source_path && ls -l | grep "^d" | wc -l`
#dir_count=33
x=0

#检查临时目录是否为空
echo " 目录下共 ${dir_count} 个子目录 "

if [ "`ls $des_path|wc -w`" > "0" ];then
	echo " 临时目录非空，将会删除 "
	rm -rf $des_path/*
else
	echo " 临时目录为空，开始拷贝  "

fi

#拷贝数据到临时目录
while [ $x -lt $dir_count ]
do
    cp $source_path/scene_$x/sync/*.bag $des_path
    cp $source_path/scene_$x/sync_fus/*.bag $des_path
    echo " 目录 $x 拷贝完成"
    x=$(( $x + 1 ))
done

cp $source_path/*.csv $des_path
