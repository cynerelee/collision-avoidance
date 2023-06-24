clc
close all
clear
s0_base=getfield(load('s0_base.mat'), 's0_tra');
s0_k1=getfield(load('s0_k1.mat'), 's0_tra');
s0_k2=getfield(load('s0_k2.mat'), 's0_tra');
s0_k3=getfield(load('s0_k3.mat'), 's0_tra');

%Ä¿±êÎ»ÖÃ
g=[0,0,-5];


plot3(s0_k1(:,1),s0_k1(:,2),s0_k1(:,3),'r');
hold on
plot3(s0_k2(:,1),s0_k2(:,2),s0_k2(:,3),'g');
hold on
plot3(s0_k3(:,1),s0_k3(:,2),s0_k3(:,3),'b');
hold on
plot3(s0_base(:,1),s0_base(:,2),s0_base(:,3),'k');
hold on
plot3(g(1),g(2),g(3),'o','MarkerSize',10);
hold on;
grid on;
set(gca,'XLim',[0,4]);
set(gca,'XTick',[0:1:4]);
set(gca,'YLim',[-4,2]);
set(gca,'YTick',[-4:1.5:2]);
set(gca,'ZLim',[-10,0]);
set(gca,'ZTick',[-10:2:0]);