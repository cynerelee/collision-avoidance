#coding:UTF-8

import scipy.io as scio
import numpy as np
import matplotlib.pyplot as plt
import matplotlib
from matplotlib.pyplot import MultipleLocator
x=np.arange(0, 150.5,0.5)

#print(x)
print(x.shape)
base = 'd_after_base.mat'
base_data = scio.loadmat(base)['d_after']
#print(base_data.shape)

d01= 'd_after_01.mat'
d01_data = scio.loadmat(d01)['d_after']


d1 = 'd_after_1.mat'
d1_data = scio.loadmat(d1)['d_after']


d5 = 'd_after_5.mat'
d5_data = scio.loadmat(d5)['d_after']


d10 = 'd_after_27.mat'
d10_data = scio.loadmat(d10)['d_after']

d25 = 'd_after_25.mat'
d25_data = scio.loadmat(d25)['d_after']
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
matplotlib.rcParams['axes.unicode_minus']=False     # 正常显示负号


# 显示横轴标签
# plt.xlabel("Time(s)",font1)
# # 显示纵轴标签
# plt.ylabel("Distance(cm)",font1)
plt.axis([0, 150, 0, 9])
plt.tick_params(labelsize=20)
x_major_locator=MultipleLocator(30)
ax.xaxis.set_major_locator(x_major_locator)
#plt.xticks([0,0.2,0.4,0.6,0.8,1,1.2,1.4,1.6,1.8,2])
plt.yticks([0,1,2,3,4,5,6,7,8,9])
labels = ax.get_xticklabels() + ax.get_yticklabels()
[label.set_fontname('Times New Roman') for label in labels]
[label.set_fontweight('bold') for label in labels]
# 显示图标题
#plt.title("频数/频率分布直方图")
#plt.legend(loc = 'upper right',prop=font2)


plt.plot(x, base_data,alpha=0.6,label='$B$',color=color[0],linewidth=2)
plt.plot(x, d01_data,alpha=0.6,label='$K_2=0.1$',color=color[1],linewidth=2)
plt.plot(x, d1_data,alpha=0.6,label='$K_2=1$',color=color[2],linewidth=2)

plt.plot(x, d5_data,alpha=0.6,label='$K_2=5$',color=color[3],linewidth=2)

plt.plot(x, d25_data,alpha=0.6,label='$K_2=25$',color=color[4],linewidth=2)
plt.plot(x, d10_data,alpha=0.6,label='$K_2=27$',color=color[5],linewidth=2)
plt.legend(loc = 0,prop=font2)

plt.savefig('distance_K2_1.png')


plt.show()
