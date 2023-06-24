#coding:UTF-8

import scipy.io as scio
import numpy as np
import matplotlib.pyplot as plt
import matplotlib
from matplotlib.pyplot import MultipleLocator
x=np.arange(0, 150.5,0.5)

#print(x)
print(x.shape)
base = 'd_after.mat'
base_data = scio.loadmat(base)['d_after']
#print(base_data.shape)

# d01= 'deviation005.mat'
# d01_data = scio.loadmat(d01)['Deviation']
#
#
# d1 = 'deviation01.mat'
# d1_data = scio.loadmat(d1)['Deviation']
#
#
# d5 = 'deviation1.mat'
# d5_data = scio.loadmat(d5)['Deviation']
#
#
# d10 = 'deviation5.mat'
# d10_data = scio.loadmat(d10)['Deviation']

font1 = {'family' : 'Times New Roman',
'weight' : 'normal',
'size':15,
}
font2 = {'family' : 'Times New Roman',
'weight' : 'normal',
'size':10,
}
color=['#377eb8', '#ff7f00', '#4daf4a','#f781bf', '#a65628', '#984ea3','#999999', '#e41a1c']
alpha=0.6
figure, ax = plt.subplots()
# 设置matplotlib正常显示中文和负号
matplotlib.rcParams['font.sans-serif']=['SimHei']   # 用黑体显示中文
matplotlib.rcParams['axes.unicode_minus']=False     # 正常显示负号


# 显示横轴标签
plt.xlabel("Time(s)",font1)
# 显示纵轴标签
plt.ylabel("Distance(cm)",font1)
plt.axis([0, 150, 0, 9])
plt.tick_params(labelsize=15)

x_major_locator=MultipleLocator(30)

ax.xaxis.set_major_locator(x_major_locator)
plt.yticks([0,2,4,6,8,10])
labels = ax.get_xticklabels() + ax.get_yticklabels()
[label.set_fontname('Times New Roman') for label in labels]

plt.plot(x, base_data,alpha=0.6,label='Proposed algorithm',color=color[0],linewidth=2)
# plt.plot(x, d01_data,alpha=0.6,label='$K_4=0.05$',color=color[1],linewidth=2)
# plt.plot(x, d1_data,alpha=0.6,label='$K_4=0.1$',color=color[2],linewidth=2)
# plt.plot(x, d10_data,alpha=0.6,label='$K_4=1$',color=color[3],linewidth=2)
# plt.plot(x, d5_data,alpha=0.6,label='$K_4=5$',color=color[4],linewidth=2)

plt.legend(loc = 0,prop=font2)

plt.savefig('distance_best.png')


plt.show()
