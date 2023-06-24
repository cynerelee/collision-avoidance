clc
% close all
clear
figure(2)
% data=xlsread('F:\Lee\相机术野追踪论文\my_track\enddd');

% t=linspace(0,2*pi,25);
% p=linspace(0,2*pi,25);
% [theta,phi]=meshgrid(t,p);
% x=5*sin(theta).*sin(phi);
% y=5*sin(theta).*cos(phi);
% z=5*cos(theta);
% surf(x,y,z,'linestyle','none');
% axis equal;
% alpha(0.1); %控制图形的透明度，取值0~1
% hold on;
RCM=[350.015100626264;-350;59.9933910019083];
R=130;  
n=30;
theta=(-n:2:n)/n*pi;
phi=([0,0:2:n])'/n*pi/2;
cosphi=cos(phi);cosphi(1)=0;cosphi(end)=0;
sintheta=sin(theta);sintheta(1)=0;sintheta(end)=0;
x=R*cosphi*cos(theta)+RCM(1);
y=R*cosphi*sintheta+RCM(2);
z=-R*sin(phi)*ones(1,n+1)+RCM(3);
surf(x,y,z,'linestyle','none');
alpha(0.9);
axis equal
hold on

R=180;  
n=30;
theta=(-n:2:n)/n*pi;
phi=([0,0:2:n])'/n*pi/2;
cosphi=cos(phi);cosphi(1)=0;cosphi(end)=0;
sintheta=sin(theta);sintheta(1)=0;sintheta(end)=0;
x=R*cosphi*cos(theta)+RCM(1);
y=R*cosphi*sintheta+RCM(2);
z=-R*sin(phi)*ones(1,n+1)+RCM(3);
surf(x,y,z,'linestyle','none');
alpha(0.1);
axis equal
hold on

% plot3(data(:,1),data(:,2),data(:,3),"r",'LineWidth',3);
% hold on
% plot3(data(:,7),data(:,8),data(:,9),'color',"b",'LineWidth',3);
% hold on 
% plot3(RCM(1),RCM(2),RCM(3),'ko','LineWidth',2);
% hold on
% plot3(data(:,4),data(:,5),data(:,6),"r",'LineWidth',3);
% hold on
% plot3(data(:,10),data(:,11),data(:,12),'color',"[0.10 0.87 0.89]",'LineWidth',3);
% hold on 
% plot3(data(:,4),data(:,5),data(:,6),"r",'LineWidth',3);
% [0.10 0.87 0.89]
% hold on


% for i=1:1:99
%     line([data(i,4),data(i,1)],[data(i,5),data(i,2)],[data(i,6),data(i,3)],'color','[0.95 0.45 0.05]');
%    
%     hold on
%     line([data(i,10),data(i,7)],[data(i,11),data(i,8)],[data(i,12),data(i,9)],'color','[0.30 0.67 0.89]');
%    
%     hold on
% end

% 创建 zlabel
zlabel('Z/mm');

% 创建 ylabel
ylabel('Y/mm');

% 创建 xlabel
xlabel('X/mm');

grid on


