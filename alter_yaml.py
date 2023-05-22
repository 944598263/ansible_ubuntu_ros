import yaml
tags = """
xm-xiongyanzhi
xm-yeyanyan
xm-helei
xm-leijun
xm-yanlili
xm-gongsongyi
xm-yaolingyong
xm-leizhangmin
xm-xuruisi
xm-zhoulijun
xm-huangquankang
xm-shaojunmin
xm-sunwei
xm-huangkai
xm-huanghaoran
xm-dongzhiwei
xm-yangpeng
xm-xujuntao
xm-zhangbaili
"""

ips = """
10.0.40.5
10.0.40.67
10.0.40.55
10.0.40.86
10.0.40.121
10.0.40.233
10.0.40.220
10.0.40.27
10.0.40.210
10.0.40.48
10.0.40.38
10.0.40.100
10.0.40.172
10.0.40.87
10.0.40.214
10.0.40.125
10.0.40.186
10.0.40.115
10.0.40.156
"""
tag_dict = {}  #初始化一个空的字典
tags = tags.split()  #拿到所有主机名，将主机名成字典

ip_dict = {}  #初始化一个空的字典
ips = ips.split()  #拿到所有ip，将ip# 存成字典

print(len(ips))#将姓名存成字典
print(ips)


i = 0
for i in range(0,len(ips)):
    #pinyin = p.get_pinyin(ips[i], '') #姓名转拼音，用''中的字符连接每个字的拼音，比如-
    print("- targets:\n  - '" + ips[i] + ":9100' \n  labels:\n    instance: " +  tags[i] +"-" + ips[i])

#f = open(r'C:\Users\tingrui.zhang\Desktop\prometheus.yml','r',encoding='utf-8')
#data = f.read()
#f.close()
#print(data)