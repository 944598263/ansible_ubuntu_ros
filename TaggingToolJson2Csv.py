import json
import logging
import os
import csv
from argparse import ArgumentParser
from datetime import datetime,timedelta


logger = logging.getLogger('TaggingToolJson2Csv')
logger.setLevel(logging.INFO)
l_format = '[%(asctime)s]\t%(levelname)s\t%(filename)s:%(funcName)s\t%(message)s'
l_formatter = logging.Formatter(l_format)
l_formatter.datefmt = '%Y-%m-%d %H:%M:%S'
stream_handler = logging.StreamHandler()
stream_handler.setFormatter(l_formatter)
logger.addHandler(stream_handler)


def list_to_csv(csv_path, header_list, data_list):
    with open(csv_path, mode="w", encoding="utf-8-sig", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(header_list)
        writer.writerows(data_list)


def _json2csv(json_path, output_dir):
    """
    读取TaggingTool生成的json文件，生成有序的csv文件
    :param json_path: TaggingTool导出json文件路径
    :param output_dir: 生成csv的保存路径
    :return: None
    """
    logger.info(f'Translate `{json_path}` start!')
    if not json_path.endswith('.json'):
        logger.error(f'`{json_path}` is not a json file!')
        return

    with open(json_path, encoding='utf-8') as f:
        json_data = json.load(f)

    scene_list = []
    for scene in json_data.get('scenes', []):
        params = scene.get('params', {})
        date_time = params.get('trigger_time')
        update_attr = params.get('update_attr', {})
        environment = params.get('environment')
        if isinstance(environment, dict):
            environment = environment.get('environment')
        _tag_type = params.get('type', '')
        environment_str = ','.join([env.get('class_item_name', '') for env in environment])
        class_name_zh, class_item_name,  = '', ''
        start_time, end_time, trigger_time, duration = '', '', '', None

        if _tag_type == 'environmentTags':
            __tag_type = '环境标签'
        elif _tag_type == 'eventTags':
            # 因为double类型的标签会存储两条记录，所以只用active_Status=start的那条就可以了，trigger_time=start_time
            if params.get('Tag_type') == 'double' and params.get('active_Status') == 'end':
                logger.debug(f'Ignore `Tag_type==double && active_Status=end` params.index:{params.get("index")}')
                continue
            __tag_type = '事件标签'
            class_name_zh = update_attr.get('className_zh')
            class_item_name = update_attr.get('class_item_name')
            start_time = update_attr.get('start_time')
            end_time = update_attr.get('end_time')
            trigger_time = update_attr.get('trigger_time')
            print(type(trigger_time))
            if trigger_time and not start_time:
                start_time = datetime.strptime(trigger_time, '%Y-%m-%d %H:%M:%S') - timedelta(seconds=delta_second)
            if trigger_time and not end_time:
                end_time = datetime.strptime(trigger_time, '%Y-%m-%d %H:%M:%S') + timedelta(seconds=delta_second)
            # if start_time and end_time:
            #     duration = str(datetime.strptime(end_time, '%Y-%m-%d %H:%M:%S') - datetime.strptime(start_time, '%Y-%m-%d %H:%M:%S'))
            environment_str = f'{environment_str},{class_item_name}'
        else:
            __tag_type = _tag_type
        row_data = [date_time, __tag_type, environment_str, class_name_zh, class_item_name, start_time, end_time, duration, trigger_time]
        scene_list.append(row_data)
    header_list = ['日期', '标签类型', '标签大类', '标签名称', '标签信息', '开始时间', '结束时间', '时长', '触发时间']
    csv_file_name = os.path.basename(json_path)[:-5] + '.csv'
    if output_dir:
        csv_path = os.path.join(output_dir, csv_file_name)
    else:
        csv_path = json_path[:-5]+'.csv'
    list_to_csv(csv_path, header_list, scene_list)
    logger.info(f'Translate `{json_path}` end! Total items:{len(scene_list)}\n')
    return scene_list


def json2csv(json_path, output_dir):
    if os.path.isfile(json_path):
        _json2csv(json_path, output_dir)
        return
    for f in os.listdir(json_path):
        json2csv(os.path.join(json_path, f), output_dir)


def main():
    parser = ArgumentParser()
    parser.add_argument("--json_path", help="tagging json file or folder path", required=True, default=None)
    parser.add_argument("--output_dir", help="folder path for save csv file", required=False, default=None)
    args = parser.parse_args()
    json_path = args.json_path
    output_dir = args.output_dir
    json2csv(json_path, output_dir)


if __name__ == '__main__':
    delta_second = 5
    main()
