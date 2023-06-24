#coding:UTF-8

import scipy.io as scio
import numpy as np
import matplotlib.pyplot as plt
import matplotlib
from matplotlib.pyplot import MultipleLocator
x=np.arange(0, 150.5,0.5)

#print(x)
print(x.shape)
base = 'deviation_base.mat'
base_data = scio.loadmat(base)['Deviation']
#print(base_data.shape)

d01= 'deviation_01.mat'
d01_data = scio.loadmat(d01)['Deviation']


d1 = 'deviation_1.mat'
d1_data = scio.loadmat(d1)['Deviation']


d5 = 'deviation_4.mat'
d5_data = scio.loadmat(d5)['Deviation']


d10 = 'deviation_3.mat'
d10_data = scio.loadmat(d10)['Deviation']

font1 = {'family' : 'Times New Roman',
'weight' : 'normal',
'size':15,
}
font2 = {'family' : 'Times New Roman',
'weight' : 'normal',
'size':18,
}
color=['#377eb8', '#ff7f00', '#4daf4a','#f781bf', '#a65628', '#984ea3','#999999', '#e41a1c']
alpha=0.6
figure, ax = plt.subplots()
# 设置matplotlib正常显示中文和负号
matplotlib.rcParams['font.sans-serif']=['SimHei']   # 用黑体显示中文
plt.rcParams["font.family"]="sans-serif"
matplotlib.rcParams['axes.unicode_minus']=False     # 正常显示负号


# 显示横轴标签
#plt.xlabel("时间/s",font1)
# 显示纵轴标签
#plt.ylabel("偏差/cm",font1)
plt.axis([0, 150, 0, 6])
plt.tick_params(labelsize=20)

x_major_locator=MultipleLocator(30)

ax.xaxis.set_major_locator(x_major_locator)
plt.yticks([0,1,2,3,4,5,6])
labels = ax.get_xticklabels() + ax.get_yticklabels()
[label.set_fontname('Times New Roman') for label in labels]
[label.set_fontweight('bold') for label in labels]

plt.plot(x, base_data,alpha=0.6,label='$Baseline$',color=color[0],linewidth=2)
plt.plot(x, d01_data,alpha=0.6,label='$K_1=0.1$',color=color[1],linewidth=2)
plt.plot(x, d1_data,alpha=0.6,label='$K_1=1$',color=color[2],linewidth=2)
plt.plot(x, d10_data,alpha=0.6,label='$K_1=3$',color=color[3],linewidth=2)
plt.plot(x, d5_data,alpha=0.6,label='$K_1=4$',color=color[4],linewidth=2)

plt.legend(loc = 0,prop=font2)

plt.savefig('deviation_K1_1.png')


plt.show()
