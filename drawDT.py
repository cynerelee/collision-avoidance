import scipy.io as scio
import numpy as np
import matplotlib.pyplot as plt
import matplotlib
from matplotlib.pyplot import MultipleLocator
x=np.arange(0, 150.5,0.5)

base = 'CT1/dt_base.mat'
base_data = scio.loadmat(base)['d_t']

dt005 = 'CT1/dt005.mat'
dt005_data = scio.loadmat(dt005)['d_t']

dt01 = 'CT1/dt01.mat'
dt01_data = scio.loadmat(dt01)['d_t']

dt1 = 'CT1/dt1.mat'
dt1_data = scio.loadmat(dt1)['d_t']

dt5 = 'CT1/dt5.mat'
dt5_data = scio.loadmat(dt5)['d_t']

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
plt.axis([0, 150, 0, 5])
plt.tick_params(labelsize=15)
x_major_locator=MultipleLocator(30)
ax.xaxis.set_major_locator(x_major_locator)
#plt.xticks([0,0.2,0.4,0.6,0.8,1,1.2,1.4,1.6,1.8,2])
plt.yticks([0,1,2,3,4,5])
labels = ax.get_xticklabels() + ax.get_yticklabels()
[label.set_fontname('Times New Roman') for label in labels]
# 显示图标题
#plt.title("频数/频率分布直方图")
#plt.legend(loc = 'upper right',prop=font2)


plt.plot(x, base_data,alpha=0.6,label='$Baseline$',color=color[0],linewidth=2)
#plt.plot(x, d01_data,alpha=0.6,label='K1=0.1',color=color[1],linewidth=2)
plt.plot(x, dt005_data,alpha=0.6,label='$K_4=0.05$',color=color[1],linewidth=2)
plt.plot(x, dt01_data,alpha=0.6,label='$K_4=0.1$',color=color[2],linewidth=2)
plt.plot(x, dt1_data,alpha=0.6,label='$K_4=1$',color=color[3],linewidth=2)
plt.plot(x, dt5_data,alpha=0.6,label='$K_4=5$',color=color[4],linewidth=2)
#plt.plot(x, d10_data,alpha=0.6,label='K1=10',color=color[4],linewidth=2)
plt.legend(loc = 0,prop=font2)
plt.savefig('CT1/Comparedt_1.png')
plt.show()
