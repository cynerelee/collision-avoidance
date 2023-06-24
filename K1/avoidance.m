clc
close all
clear
%两个RCM
s=[0,0,0];
m=[-10,0,0];

%相关参数
D=3;
D1=2;
beta=pi/4;

K1=10;
K2=0;
K3=0;
K4=0;
K5=0;
K6=0.02;

Vmax=1;

%相关变量
Ls=28;%robom-controlled insmrument length器械轴长单位cm
ls_tip=3;%tip length
s_tip_degree=0;%器械张开角度
rs=0.5;%器械轴的半径

Lm=28;%surgeon-controlled insmrument length
lm_tip=3;%surgeon-controlled insmrument tip length
% m_tip_degree=30;%器械张开角度
rm=0.5;

%初始位置robot-controlled instrument
s0=[1.3843,1.0173,-9.9648];%末端点
ez=(s0-s)/norm(s0-s);
Ls_tip=ls_tip*cos(s_tip_degree/180*pi);
s1=s0-ez*Ls_tip;
ls=norm(s1-s);
s2=s-(Ls-ls)*ez;

%surgeon-controlled instrument
m0=[3,4,-10];
% mz=(m0-m)/norm(m0-m);
% Lm_tip=lm_tip*cos(m_tip_degree/180*pi);
% m1=m0-mz*Lm_tip;
% lm=norm(m1-m);
% m2=m-(Lm-lm)*mz;
mm=m0;

%目标位置
g=[0,0,-5];

%体内环境
% RCM=m;
% R=15;
% n=60;
% theta=(-n:2:n)/n*pi;
% phi=([0,0:2:n])'/n*pi/2;
% x=R*cos(phi)*cos(theta)+RCM(1);
% y=R*cos(phi)*sin(theta)+RCM(2);
% z=-R*sin(phi)*ones(1,n+1)+RCM(3);
% x1=x(:)-randi(4,1952,1);
% y1=y(:)-randi(4,1952,1);
% z1=z(:)+randi(4,1952,1);
load('x1.mat');
load('y1.mat');
load('z1.mat');



%算法
number=0;
% for t=1:0.01:4
%     number=number+1;
%     m_tip_degree(number)=rand()*30;
% end
% m_tip_degree=xlsread('m_tip_degree.xlsx');
load('m_tip_degree.mat')

for t=1:0.01:4
    number=number+1;
%     figure(1);

%     scatter3(x1,y1,z1,'.');
%     alpha(0.1);
%     axis equal
%     hold on;
%     grid on;
%     plot3(s(1),s(2),s(3),'*','MarkerSize',10);
%     hold on;
%     plot3(g(1),g(2),g(3),'o','MarkerSize',10);
%     hold on;
%     plot3(m(1),m(2),m(3),'*','MarkerSize',10);
%     hold on;
    
    m0=[mm(1)+10*sin(t*pi) mm(2)+10*sin(t*pi) mm(3)+sin(t*pi)];
%     m_tip_degree=rand()*30;
    mz=(m0-m)/norm(m0-m);
    Lm_tip=lm_tip*cos(m_tip_degree(number)/180*pi);
    m1=m0-mz*Lm_tip;
    lm=norm(m1-m);
    m2=m-(Lm-lm)*mz;
%     Funcylinder(m1,m2,rm);
%     hold on;
%     Funcylinder(m0,m1,lm_tip*sin(m_tip_degree(number)/180*pi));
%     hold on;
    
%     Funcylinder(s1,s2,rs);
%     hold on;
%     Funcylinder(s0,s1,rs);
%     hold on;
    
    %最短距离求解
    %robot-controlled instrument
    rm_tip=lm_tip*sin(m_tip_degree(number)/180*pi);
    if rm_tip<rm
        rt_tip=rm;
    end
    [sj1,mj1,d1]=funcDistance(s0,s1,s0,rs,m0,m1,m0,rm_tip);
    [sj2,mj2,d2]=funcDistance(s0,s1,s0,rs,m1,m2,m1,rm);
    [sj3,mj3,d3]=funcDistance(s1,s2,s1,rs,m0,m1,m0,rm_tip);
    [sj4,mj4,d4]=funcDistance(s1,s2,s1,rs,m1,m2,m1,rm);
    
    d=min([d1 d2 d3 d4]);
    d_begin(number,:)=d;
   
    if d==d1
        sj=sj1;
        mj=mj1;
    elseif d==d2
        sj=sj2;
        mj=mj2;
    elseif d==d3
        sj=sj3;
        mj=mj3;
    else
        sj=sj4;
        mj=mj4;          
    end
%     plot3([sj(1) mj(1)],[sj(2) mj(2)],[sj(3) mj(3)],'g','LineWidth',2);     
%     str=['distance:',num2str(d),'cm'];
%     text(23,23,0,str);
    %CI vector
    if sj==s
        if mj(3)>0
            s_s=s+(s2-s)/norm(s2-s);
            [sj,mj,d]=funcDistance(s_s,s2,s_s,rs,m,m2,m,rm);
        else
            s_s=s-(s2-s)/norm(s2-s);
            [sj,mj,d]=funcDistance(s0,s_s,s0,rs,m1,m,m1,rm);     
        end
    end
    ii=(s-s0)/norm(s-s0);
    j=sj-mj;
    j=j-norm(j)*ii;
    j=j/norm(j);
    k=cross(ii,j);
        
    Direction_j=cross(ii,cross(j/norm(j),ii));%远离
        
    Direction_i=cross(j/norm(j),ii);%绕
        
    Direction_k=ii;%往上提
        
    if Direction_i*(m0-m)'<0
        Direction_i=-Direction_i;
    end
    if d>D
        CI1=[0 0 0];
        CI2=[0 0 0]; 
        CI3=[0 0 0];
    else        
        CI1=K1*D^2*(D-d)/(d^4)*Direction_i;
        CI2=K2*D^2*(D-d)/(d^4)*Direction_j;
        CI3=K3*D^2*(D-d)/(d^4)*(exp(4*norm(sj-s0)/norm(s-s0)))*Direction_k; 
    end  
    
    if norm(CI1)>Vmax
        CI1=CI1/norm(CI1)*Vmax;     
    end
    if norm(CI2)>Vmax
        CI2=CI2/norm(CI2)*Vmax;     
    end
    if norm(CI3)>Vmax
        CI3=CI3/norm(CI3)*Vmax;     
    end
    
      %CT vector
    CT1=[0 0 0];
    count(number,:)=0;
    d_t(number,:)=100;
   
    for i=1:length(x1)
        
        rt=norm([x1(i),y1(i),z1(i)]-s0); 
        d_t(number,:)=min(d_t(number,:),rt);
        
        rt_direction=([x1(i),y1(i),z1(i)]-s0)/rt;
        if rt<D1
            count(number,:)=count(number,:)+1;
            CT1=CT1-K4*cos(rt/(2D1)*pi)*rt_direction;
        end
        
    end
    if count(number,:)>0
        CT1=CT1/count(number,:);
    end
    
    ez=(s0-s)/norm(s0-s);
    n=[0,0,-1];
%     acos(dot(ez,n)/(norm(n)));
    if acos(dot(ez,n)/(norm(n)))>beta
        CT2_direction=cross(cross(ez,[0,0,-1]),ez);
        CT2=K5*dot(ez,n)/(norm(n))*CT2_direction;
    else
        CT2=([0,0,0]);
    end 
    
    if norm(CT1)>Vmax
        CT1=CT1/norm(CT1)*Vmax;     
    end
    if norm(CT2)>Vmax
        CT2=CT2/norm(CT2)*Vmax;     
    end
    Deviation(number,:)=norm(g-s0);
    
     
    %CC vector
    CC=K6*(g-s0);
    if norm(CC)>Vmax
        CC=CC/norm(CC)*Vmax;     
    end
    
    V=CI1+CI2+CI3+CT1+CT2+CC;
    if norm(V)>Vmax
        V=V/norm(V)*Vmax;
    end
%     V=[0 0 0];
    s0=s0+V*t;
    ez_after=(s0-s)/norm(s0-s);
    s1=s0-ls_tip*ez_after;
    
    
    s2=s0-(Ls+ls_tip)*ez_after;
    [sj1,mj1,d1]=funcDistance(s0,s2,s0,rs,m0,m1,m0,lm_tip*sin(m_tip_degree(number)/180*pi));
    [sj2,mj2,d2]=funcDistance(s0,s2,s0,rs,m1,m2,m1,rm);
    d_after(number,:)=min([d1,d2]);
    
    
    
    
   
    
    
    
    
    
    

    
%     set(gca,'XLim',[-30,18]);
%     set(gca,'XTick',[-30:6:18]);
%     set(gca,'YLim',[-24,24]);
%     set(gca,'YTick',[-24:6:24]);
%     set(gca,'ZLim',[-24,18]);
%     set(gca,'ZTick',[-24:6:18]);
%     
%    
%     
%     hold off;
    
    
    
    
end







