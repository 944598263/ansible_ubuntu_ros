#!/usr/bin/env python2
import os

import argparse
import numpy as np
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
import rospy
import rosbag


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='create empty ld_object_lists')
    parser.add_argument('--input', type=str)
    parser.add_argument('--topic', type=str, default='/os_cloud_node/points')
    parser.add_argument('--threshold', type=int, default=0.067)
    args = parser.parse_args()

    input_file = args.input
    read_topic = args.topic
    threshold = args.threshold

    count = 0
    pre_timestamp = 0
    timestamp_diff = 0
    bad_conunt = 0
    X = []
    Y = []
    with rosbag.Bag(input_file, mode='r') as bag:
        for topic, msg, t in bag.read_messages(topics=read_topic):
            count += 1
            if count == 1:
                pre_timestamp = msg.header.stamp
            else:
                timestamp_diff = msg.header.stamp - pre_timestamp
                pre_timestamp = msg.header.stamp
                print count, '-', count-1, ':', timestamp_diff.to_sec()
                X.append(count)
                Y.append(timestamp_diff.to_sec())
                if timestamp_diff.to_sec() > threshold:
                    bad_conunt += 1
        print 'bad_conunt/total_count: ', bad_conunt, '/', count

    fig = plt.figure()
    plt.bar(X, Y, 0.8, color="blue")
    plt.xlabel("Count")
    plt.ylabel("TsDiff")
    plt.title("timestamps diff")

    plt.show()
