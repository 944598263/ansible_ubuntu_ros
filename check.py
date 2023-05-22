# -*- coding: utf-8 -*-
import os
import argparse
# 创建ArgumentParser对象
parser = argparse.ArgumentParser()
parser.add_argument("dir_path", help="目录路径")
args = parser.parse_args()
# 获取目录路径
dir_path = args.dir_path
# 定义空列表存储所需的信息
trip_infos = []
LDE_infos = []
OPP_infos = []
missing_infos = []
missing1_infos = []
missing2_infos = []
# 循环遍历目录下的所有子目录
for dir_name in os.listdir(dir_path):
    sub_dir_path = os.path.join(dir_path, dir_name)
    if not os.path.isdir(sub_dir_path):
        continue
    # 从子目录名称中截取需要的信息并存储到变量中
    trip_info = "_".join(dir_name.split("_")[:3])
    # 将所需的信息添加到列表中
    trip_infos.append(trip_info)
    # 构造需要遍历的目录路径
    acc_dir_path = os.path.join(sub_dir_path, "Acc_OD_MERGE_OPP_LDE")
    # 检查路径是否存在，如果不存在则跳过
    if not os.path.isdir(acc_dir_path):
        continue
    # 循环遍历Acc_OD_MERGE_OPP_LDE目录下的所有文件
    for file_name in os.listdir(acc_dir_path):
        # 构造文件的完整路径
        file_path = os.path.join(acc_dir_path, file_name)
        # 检查文件是否是目录，如果是则跳过
        if os.path.isdir(file_path):
            continue
        # 从文件名中截取需要的信息并存储到变量中
        LDE_info = "_".join(file_name.split("_")[1:4])
        # 比较子目录名称和文件的前三个信息并输出结果
        if trip_info == LDE_info:
            print(" Acc_OD_MERGE_OPP_LDE ok ", trip_info)
        else:
            print("Please check the files under Acc_OD_MERGE_OPP_LDE", LDE_info)
        # 将所需的信息添加到列表中
        LDE_infos.append(LDE_info)
    # 检查是否有符合命名规则的文件，如果没有则将子目录信息添加到missing_infos列表中
    if trip_info not in LDE_infos:
        missing_infos.append(trip_info)
# 打印出没有符合命名规则的文件的子目录信息
    if len(missing_infos) > 0:
        print("\nThe following directories have no files under Acc_OD_MERGE_OPP_LDE:")
    for trip_info in missing_infos:
        print(trip_info)

    acc1_dir_path = os.path.join(sub_dir_path, "Acc_OD_MERGE_OPP_OPP")
    # 检查路径是否存在，如果不存在则跳过
    if not os.path.isdir(acc1_dir_path):
        continue
    # 循环遍历Acc_OD_MERGE_OPP_OPP目录下的所有文件
    for file1_name in os.listdir(acc1_dir_path):
        # 构造文件的完整路径
        file_path = os.path.join(acc1_dir_path, file1_name)
        # 检查文件是否是目录，如果是则跳过
        if os.path.isdir(file_path):
            continue
        # 从文件名中截取需要的信息并存储到变量中
        OPP_info = "_".join(file1_name.split("_")[1:4])
        # 比较子目录名称和文件的前三个信息并输出结果
        if trip_info == OPP_info:
            print(" Acc_OD_MERGE_OPP_OPP ok ",trip_info)
        else:
            print("Please check the files under Acc_OD_MERGE_OPP_OPP",OPP_info)
        # 将所需的信息添加到列表中
        OPP_infos.append(OPP_info)
    # 检查是否有符合命名规则的文件，如果没有则将子目录信息添加到missing1_infos列表中
    if trip_info not in OPP_infos:
        missing1_infos.append(trip_info)
# 打印出没有符合命名规则的文件的子目录信息
    if len(missing1_infos) > 0:
        print("\nThe following directories have no files under Acc_OD_MERGE_OPP_OPP:")
    for trip_info in missing1_infos:
        print(trip_info)

    acc2_dir_path = os.path.join(sub_dir_path, "Org_CSV")
    for file2_name in os.listdir(acc2_dir_path):
        file_path = os.path.join(acc2_dir_path, file2_name)
    # 检查路径是否存在，如果不存在则输出对应的 trip_info
        if not os.path.isdir(acc2_dir_path):
            print("Directory not found for", trip_info)
    else:
        # 判断 Org_CSV 目录是否为空，并输出相应结果
        if len(os.listdir(acc2_dir_path)) == 0:
            print("Please check the files under Org_CSV in", trip_info)
        else:
            print("Org_CSV ok", trip_info)
print('\n')


