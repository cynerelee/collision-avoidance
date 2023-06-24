import matplotlib.pyplot as plt
import matplotlib
import numpy as np
import xlrd #读取excel的库
x=np.arange(0, 2.01,0.01)

#print(x)
#print(x.shape)
data1 = xlrd.open_workbook("deviation_k1.xlsx")
table1 = data1.sheet_by_index(0)
line=table1.col_values(0)
base=np.array(line)
base=base.T

resArray=[] #先声明一个空list
data = xlrd.open_workbook("deviation_k3.xlsx") #读取文件
table = data.sheet_by_index(0) #按索引获取工作表，0就是工作表1
for i in range(table.nrows): #table.nrows表示总行数
    line=table.row_values(i) #读取每行数据，保存在line里面，line是list
    resArray.append(line) #将line加入到resArray中，resArray是二维list
resArray=np.array(resArray) #将resArray从二维list变成数组

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
plt.axis([0, 2, 0, 6])
plt.tick_params(labelsize=15)
plt.xticks([0,0.2,0.4,0.6,0.8,1,1.2,1.4,1.6,1.8,2])
plt.yticks([0,1,2,3,4,5,6])
labels = ax.get_xticklabels() + ax.get_yticklabels()
[label.set_fontname('Times New Roman') for label in labels]
# 显示图标题
#plt.title("频数/频率分布直方图")
#plt.legend(loc = 'upper right',prop=font2)


plt.plot(x, base,alpha=0.6,label='Baseline',color=color[0],linewidth=2)
plt.plot(x, resArray[:,1],alpha=0.6,label='K2=0.1',color=color[1],linewidth=2)
plt.plot(x, resArray[:,2],alpha=0.6,label='K2=1',color=color[2],linewidth=2)
plt.plot(x, resArray[:,3],alpha=0.6,label='K2=5',color=color[3],linewidth=2)
plt.plot(x, resArray[:,4],alpha=0.6,label='K2=10',color=color[4],linewidth=2)
plt.legend(loc = 0,prop=font2)

plt.savefig('./Deviation_k3.png')


plt.show()