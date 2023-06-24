clc
close all
clear
data=xlsread('distance');
figure(1);
%axis equal;
hold on;
%…Ë÷√◊¯±Í÷·label
 xlabel('Time(s)', 'Fontname','Times New Roman','FontSize',16);
 ylabel('Deviation(cm)', 'Fontname','Times New Roman','FontSize',16);
 %ylabel('Distance(mm)', 'Fontname','Times New Roman','FontSize',16);

% set(gca,'YLim',[0,162])
% set(gca,'YTick',[0:18:162]);
x=0:0.01:2;

y1=data(:,1);
y2=data(:,2);
y3=data(:,3);
y4=data(:,4);
y5=data(:,5);
base=ones(201,1)*3;

grid on; 
plot(x,y1,'r');
hold on;
plot(x,y2,'g');
hold on;
plot(x,y3,'b');
hold on;
plot(x,y4,'m');
hold on;
plot(x,y5,'k');
hold on;
% plot(x,base);
% hold on;
