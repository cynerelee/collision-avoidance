#coding:UTF-8

import scipy.io as scio
import numpy as np
import matplotlib.pyplot as plt
import matplotlib
from matplotlib.pyplot import MultipleLocator
x=np.arange(0, 3.01,0.01)

#print(x)
base = 'CT1/Deviation_base.mat'
base_data = scio.loadmat(base)['Deviation']

Deviation005 = 'CT1/Deviation005.mat'
Deviation005_data = scio.loadmat(Deviation005)['Deviation']

Deviation01 = 'CT1/Deviation01.mat'
Deviation01_data = scio.loadmat(Deviation01)['Deviation']

Deviation1 = 'CT1/Deviation1.mat'
Deviation1_data = scio.loadmat(Deviation1)['Deviation']

Deviation5 = 'CT1/Deviation5.mat'
Deviation5_data = scio.loadmat(Deviation5)['Deviation']

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
plt.ylabel("Deviation(cm)",font1)
plt.axis([0, 1.6, 0, 6])
plt.tick_params(labelsize=15)

x_major_locator=MultipleLocator(0.2)

ax.xaxis.set_major_locator(x_major_locator)
plt.yticks([0,1,2,3,4,5,6])
labels = ax.get_xticklabels() + ax.get_yticklabels()
[label.set_fontname('Times New Roman') for label in labels]

plt.plot(x, base_data,alpha=0.6,label='$Baseline$',color=color[0],linewidth=2)
plt.plot(x, Deviation005_data,alpha=0.6,label='$K_4=0.05$',color=color[1],linewidth=2)
plt.plot(x, Deviation01_data,alpha=0.6,label='$K_4=0.1$',color=color[2],linewidth=2)
plt.plot(x, Deviation1_data,alpha=0.6,label='$K_4=1$',color=color[3],linewidth=2)
plt.plot(x, Deviation5_data,alpha=0.6,label='$K_4=5$',color=color[4],linewidth=2)
plt.legend(loc = 0,prop=font2)

plt.savefig('CT1/deviation.png')


plt.show()
