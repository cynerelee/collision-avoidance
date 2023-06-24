import matplotlib as mpl
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
import matplotlib.pyplot as plt
import numpy as np
import scipy.io as scio
from matplotlib.pyplot import MultipleLocator

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

base = 's0_tra.mat'
base_data = scio.loadmat(base)['s0_tra']
print(base_data.shape)

mpl.rcParams['legend.fontsize'] = 10

fig = plt.figure()
ax = fig.gca(projection='3d')
# 显示横轴标签
plt.xlabel("X(cm)",font1)
plt.ylabel("Y(cm)",font1)
ax.set_zlabel('Z(cm)',font1)
ax.set_xlim(-0.4, 1.6)
ax.set_ylim(-0.5, 1)
ax.set_zlim(-9, -1)
plt.tick_params(labelsize=15)
x_major_locator=MultipleLocator(0.4)
y_major_locator=MultipleLocator(0.5)
z_major_locator=MultipleLocator(2)

ax.xaxis.set_major_locator(x_major_locator)
ax.yaxis.set_major_locator(y_major_locator)
ax.zaxis.set_major_locator(z_major_locator)
#theta = np.linspace(-4 * np.pi, 4 * np.pi, 100)
# z = np.linspace(-2, 2, 100)
# r = z ** 2 + 1
# x = r * np.sin(theta)
# y = r * np.cos(theta)
labels = ax.get_xticklabels() + ax.get_yticklabels()+ax.get_zticklabels()
[label.set_fontname('Times New Roman') for label in labels]
ax.plot(base_data[:,0], base_data[:,1], base_data[:,2], alpha=0.6,label='Proposed algorithm',color=color[0],linewidth=2)
plt.legend(loc = 0,prop=font2)
plt.savefig('tra_best.png')
plt.show()