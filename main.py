from xpinyin import Pinyin  #导入Pinyin
p = Pinyin()
#地域或厂商缩写 保定：bd_ 云测：yc_ 马达：md_
diyu = "xm-"
#pinyin = p.get_pinyin()
s = """
熊艳芝
叶艳艳
何磊
雷俊
严利莉
巩松艺
姚龄勇
雷张敏
许瑞斯
周戾军
黄全康
邵俊敏
孙伟
黄凯
黄浩然
董志伟
杨鹏
徐俊韬
张白莉
"""
name_dict = {}  #初始化一个空的字典
names = s.split()  #拿到所有人名，将姓名存成字典
#print(names)将姓名存成字典
i = 0
for i in range(0,len(names)):
    pinyin = p.get_pinyin(names[i], '') #姓名转拼音，用''中的字符连接每个字的拼音，比如-
    print(diyu + pinyin)