#coding:UTF-8

import scipy.io as scio
import numpy as np
import matplotlib.pyplot as plt
import matplotlib
from matplotlib.pyplot import MultipleLocator
x=np.arange(0, 150.5,0.5)

print(x.shape)
base = 'current_beta.mat'
base_data = scio.loadmat(base)['current_beta']

base_data=base_data*180/3.1415926

#current_beta005 = 'CT2/current_beta005.mat'
#current_beta005_data = scio.loadmat(current_beta005)['current_beta']

# current_beta01 = 'CT2/current_beta01.mat'
# current_beta01_data = scio.loadmat(current_beta01)['current_beta']
# current_beta01_data=current_beta01_data*180/3.1415926
#
# current_beta1 = 'CT2/current_beta1.mat'
# current_beta1_data = scio.loadmat(current_beta1)['current_beta']
# current_beta1_data=current_beta1_data*180/3.1415926
#
# current_beta5 = 'CT2/current_beta5.mat'
# current_beta5_data = scio.loadmat(current_beta5)['current_beta']
# current_beta5_data=current_beta5_data*180/3.1415926
#
# current_beta10 = 'CT2/current_beta10.mat'
# current_beta10_data = scio.loadmat(current_beta10)['current_beta']
# current_beta10_data=current_beta10_data*180/3.1415926

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
plt.ylabel("Included angle(degree)",font1)
plt.axis([0, 150, 0, 90])
plt.tick_params(labelsize=15)

x_major_locator=MultipleLocator(30)
y_major_locator=MultipleLocator(15)

ax.xaxis.set_major_locator(x_major_locator)
ax.yaxis.set_major_locator(y_major_locator)

labels = ax.get_xticklabels() + ax.get_yticklabels()
[label.set_fontname('Times New Roman') for label in labels]

plt.plot(x, base_data,alpha=0.6,label='Proposed algorithm',color=color[0],linewidth=2)
# plt.plot(x, current_beta01_data,alpha=0.6,label='$K_5=0.1$',color=color[1],linewidth=2)
# plt.plot(x, current_beta1_data,alpha=0.6,label='$K_5=1$',color=color[2],linewidth=2)
# plt.plot(x, current_beta5_data,alpha=0.6,label='$K_5=5$',color=color[3],linewidth=2)
# plt.plot(x, current_beta10_data,alpha=0.6,label='$K_5=10$',color=color[4],linewidth=2)
plt.legend(loc = 0,prop=font2)

plt.savefig('beta_best.png')


plt.show()
