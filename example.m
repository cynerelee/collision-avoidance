 clc
 close all
 clear

%定义机器人外形
d1=89.459;
a2=-425;
a3=-392.25;
d4=109.15;
d5=94.65;
d6=82.3;
Rpara=[d1 a2 a3 d4 d5 d6];
%DH参数模型
L1=Link([0 d1 0 pi/2]);
L2=Link([0 0 a2 0 ]);
L3=Link([0 0 a3 0 ]);
L4=Link([0 d4 0 pi/2]);
L5=Link([0 d5 0 -pi/2 ]);
L6=Link([0 d6 0  0]);

Rbt=SerialLink([L1 L2 L3 L4 L5 L6]);
Rbt.name='UR5'

q0=[ 0  -pi/2 pi/3  -pi/3 pi/6 -pi/4];
qsq1=[ pi/6 -pi/2  0  0 -pi/2 0 ];

% % qsq2=[.81681 0.56549 0 1.0681 0 1.2566];
% % qsq3=[2.36 0.69115 0 0.848 0 1.4451];
% % qsq4=[2.66 0.37699 0 1.31 0 1.4451];
% % qsq5=[pi/2 0.62831 0 1.5708 0 0.94249];
% % qsq6=[0 0.62831 0 1.5708 0 0.94249];

%规划机器人轨迹 
ttt=0:.04:2;
sqtraj1=jtraj(q0,qsq1,ttt); 

%画图 
hold on
atj=zeros(4,4);
view(-35,40)
xlim([-700,400])
ylim([-600,600])
zlim([0,800])
seta=0;
% 创建视频头文件
writerObj = VideoWriter('needle7k.avi');
open(writerObj);
%位姿计算
target1.position=[-300,0,300]';
target2.position=[-330,20,50]';
target1.zi=(target2.position-target1.position)/norm(target2.position-target1.position);
target2.zi=target1.zi;
target1.endp=target1.position-200*target1.zi;
target2.endp=target2.position-200*target1.zi;


%最关键的两句，将机器人位姿调整到sqtraj1(1,:)，和输出机器人末端位姿，输出位姿jta为位姿描述矩阵；
atj=Rbt.fkine(sqtraj1(1,:)); %前向运动学求解
jta=transpose(atj);

%目标点
Katt=200;

%Drep=80;
Drep=100;
Krep=1000000000;
dl=0;
Vmax=40;


%%
% 
startpoint.position=jta.t;
startpoint.zi=jta.a;
zi=target1.zi;
xj=-cross(zi,jta.o);
xj=xj/norm(xj);
xj=cos(seta).*xj+(1-cos(seta))*(xj*zi')*zi+sin(seta)*cross(zi,xj);
yk=cross(zi,xj);
R=[xj,yk,zi];
A=target1.endp;
jta2=SE3(R,A');
theta=Ndynamic(jta2,Rpara,sqtraj1(1,:));
min=1000;
for j=1:8
    if min>norm(theta(j,:)-sqtraj1(1,:))
       min=norm(theta(j,:)-sqtraj1(1,:))
%                sqtraj1(i,5)
       qsq1=theta(j,:);
    end     
%         atj3=transpose(Rbt.fkine(theta(i,:)));
end

sqtraj1(1,:)=qsq1;
B1=A+150*zi;
B2=B1-[150,0,0]';
m=B2-[0,0,200]';
L=400;
s=B1';
t=B2';
s0=A'+400*zi';
g=s0;
number=0;
Vlast=0;
Vbar=0;

%s腔镜创口点，s0腔镜末端点，t器械创口点，t0器械末端点
%%
distance=[];
deviation=[];
S0=[];
W=[];
VV=[];

for i=1:1:200
    %%
    number=number+1;
    atj=Rbt.fkine(sqtraj1(i,:));
    jta=transpose(atj);
    jta2=jta;
    if i==1
        %机器人位姿初始化
       startpoint.position=jta.t; 
       startpoint.zi=jta.a;
%        xj=-cross(zi,jta.o);
%        xj=xj/norm(xj);
%        xj=cos(seta).*xj+(1-cos(seta))*(xj*zi')*zi+sin(seta)*cross(zi,xj);
%        yk=cross(zi,xj);
%        R=[xj,yk,zi];
%        
    end
    %手持机构位姿

     l=0.01*i;
   %  t0=[g(1)+180*sin(l*pi) g(2)+180*sin(l*pi) g(3)+3*sin(l*pi)];
     t0=[m(1)+180*norm(sin(l*pi)) m(2)+180*cos(l*pi) m(3)+3*sin(l*pi)];
   %  t0=[m(1)+180*norm(sin(l*pi)) m(2)+180*cos(l*pi) m(3)+sin(l*pi)];
     s1=s0-L*(s0-s)/norm(s-s0);
     Sxyz(number,:)=s1;
     t1=t0-L*(t0-t)/norm(t-t0);
    %最短距离
    [sj,tj,w]=funcDistance(s0,s,t0,t);
    S0(i,:)=s0;
  %  distance(i,:)=w;
  %  disp(w);
    
    
    %%
    %避障求解
    if sj==s
        ii=(s-s0)/norm(s-s0);
        s2=s-ii;
        [sj1,tj1,w1]=funcDistance(s0,s2,t0,t);
        j=sj1-tj1;
        j=j-norm(j)*ii;
        j=j/norm(j);
        k=cross(ii,j);
        
        Direction1=cross(ii,cross(j/norm(j),ii));
        Direction2=cross(j/norm(j),ii);
        if Direction2*(t0-t)'<0
            Direction2=-Direction2;
        end
        if w>Drep
            a1=[0 0 0];
            a3=[0 0 0];
            a5=[0 0 0];
        else
            Frep=Drep^3*(1/w1-1/Drep)/(w1*w1);
%             a1=Frep*j;
            a1=Frep*Direction1;
            a3=Frep*(exp(norm(sj-s0)/norm(s-s0)))*(s-s0)/norm(s-s0); 
            a5=Frep*Direction2;
        end
        if dot(t-t0,k)>=0
             v3=1/w1*norm(s0-s)*k;
         else
             v3=-1/w1*norm(s0-s)*k;
         end
    else
        ii=(s-s0)/norm(s-s0);
        j=sj-tj;
        j=j-norm(j)*ii;
        j=j/norm(j);
        k=cross(ii,j);
        
        Direction1=cross(ii,cross(j/norm(j),ii));
        Direction2=cross(j/norm(j),ii);
        if Direction2*(t0-t)'<0
            Direction2=-Direction2;
        end
        if w>Drep
            a1=[0 0 0];
            a3=[0 0 0]; 
            a5=[0 0 0];
        else
            Frep=Drep^3*(1/w-1/Drep)*1/(w*w);
%             a1=Frep*j;
            a1=Frep*Direction1;
            a3=Frep*(exp(4*norm(sj-s0)/norm(s-s0)))*(s-s0)/norm(s-s0); 
            a5=Frep*Direction2;
        end
        if dot(t-t0,k)>=0
             v3=1/w*norm(s0-s)*k;
         else
             v3=-1/w*norm(s0-s)*k;
         end
        
    end
%     Katt=exp(norm(s0-g))-1;
    Fatt=Katt*norm(s0-g);
    a2=Fatt*(g-s0)/(norm(g-s0)+0.00001);

%     a2=sign(g(3)-s0(3))*Fatt*norm(g-s0)*(s-s0)/norm(s-s0);
    
%     a3=(exp(norm(sj-s0))-1)*(s-s0)/norm(s-s0); 
    cosa=dot((s0-s),[0,0,-1])/norm(s0-s);
    if cross((s0-s),[0,0,-1])==[0 0 0]
        a4=0;
    else
        j=cross(cross((s0-s),[0,0,-1]),(s0-s));
        j=j/norm(j);
        a4=cosa*j;
    end
  %  a1=0;% 远离
   %  a2=0;% 吸引至目标点
   %  a3=0;% 上升
   %  a4=0;% 倾角约束
   % a5=0;% 绕开
  %  v3=0;% 

  % V=3*a5+5*a1+5*a3+0.001*a2+a4;%%第一组参数
 %  V=8*a5+0.001*a2+a4;%%第2组参数
% V=5*a1+0.001*a2+a4;%%第3组参数
%V=a3+0.001*a2+a4;%%第4组参数
   % V=a5+0.001*a2+a4;
  %   V=0.5*a1+0.001*a2+1*a3+a4+1.5*a5+10*v3;
  %V=8*a5+5*a1+0.001*a2+a4;%%%%%4a 1+2
 % V=4*a5+a3+0.001*a2+a4;%%%4b  1+3
%  V=5*a1+a3+0.001*a2+a4;%%%4c  2+3
 %V=a5+2*a1+3*a3+0.001*a2+a4;%%
% V=2*a5+2*a1+3*a3+0.001*a2+a4;%%
V=2*a5+6*a1+2*a3+0.001*a2+a4;
   Vbar=0.6*V+0.4*Vbar;
    
    
%     Vlast=Vbar;
    V=Vbar;
    if norm(V)>Vmax
        V=Vmax*V/norm(V);
    end
  %  V=[0 0 0];
 Vxyz(number,:)=V;
 W(number,:)=V/(norm(s0-s));
 VV(number,:)=-V/(norm(s0-s))*(L-norm(s0-s));
  RCM_V(number,:)=funcSpeedNew(s0,V,s,s1,L);
      s0=s0+0.2*V;
      
     [sj,tj,w]=funcDistance(s0,s,t0,t);
     distance(i,:)=w;
     deviation(i,:)=norm(s0-g);
    
    %%
%机器人运动规划，修改该字段，就可以实现机器人的控制。
%     A=jta.t+[10*(sin(pi*(i+1)/20)-sin(pi*i/20)),30*(sin(pi*(i+1)/30)-sin(pi*i/30)),0]';
%     A=jta.t;
    A=s0'-L*(s0'-s')/norm(s0'-s');

    zi=((s0'-s')/norm(s0'-s'))';
%     zi=((B1-A)/norm(A-B1))';
    xj=-cross(zi,jta.o);
    xj=xj/norm(xj);
    xj=cos(seta).*xj+(1-cos(seta))*(xj*zi')*zi+sin(seta)*cross(zi,xj);
    yk=cross(zi,xj);
    R=[xj',yk',zi'];%方向矩阵，三个向量分别代表x,y,z三个方向的单位向量
%     A=B1-400*(0.4*cos(pi*(i-1)/50)+0.6)*zi';%位置向量，即机器人末端的空间坐标【x,y,z】
    jta2=SE3(R,A');

%     jta2.n=jta.n;
%     jta2.o=jta.o;
%     jta2.a=jta.a;
%     jta2.t=A;
%求解机器人运动学逆解，机器人不运动或出错，可能是由于超出了机器人的工作空间
    theta=Ndynamic(jta2,Rpara,sqtraj1(i,:));
    min=1000;
    for j=1:8
        if min>norm(theta(j,:)-sqtraj1(i,:))
           min=norm(theta(j,:)-sqtraj1(i,:));
         %  sqtraj1(i,5)
           sqtraj1(i+1,:)=theta(j,:);
        end
        if min>2
            sqtraj1(i+1,:)=sqtraj1(i,:);
            %disp("超出机器人运动空间");
        end
        
    end
    atj3=transpose(Rbt.fkine(sqtraj1(i+1,:)));
%     At(1,:)=A';
%     At(2,:)=A'+L*(s0-s)/norm(s0'-s');
    A=atj3.t;
    At(1,:)=atj3.t';
    At(2,:)=At(1,:)+L*atj3.a';
    Ct(1,:)=t0;
    Ct(2,:)=t0+400*(t-t0)/norm(t-t0);
    JTA(i,:)=jta.t;
    jta=JTA;
%     Bt(i,:)=B'+[sin(i) 0 0];
    Bt1(i,:)=B1';
    Bt2(i,:)=B2';
    if i>1
        delete(needle1)
        delete(needle2)
    end
    
    needle1=plot2(At,'r','LineWidth',2);
    needle2=plot2(Ct,'b','LineWidth',2);
    
%     plot2(jta(i,:),'r.')
    Rbt.plot(sqtraj1(i+1,:),'nowrist')


   % plot2(JTA,'k.')
    plot2(Bt1,'g+')
    plot2(Bt2,'B*')
    plot2(g,'ro')

   frame = getframe(1);
   %imgPath = ['./' mat2str(number) '.png']; % 组合保存路径和图片名称
  % saveas(gcf,imgPath);
   
   writeVideo(writerObj,frame);

    
    
%     plot2(At,'Y+')
    
%     figure(1)
%     hold on
%     funcCylinder(A',B',100,2,1);
    
end
% figure(3);
% plot3(g(1,1),g(1,2),g(1,3),'ko','MarkerFaceColor','k');
% hold on;
% plot3(S0(:,1),S0(:,2),S0(:,3),'r');
% hold on;
% grid on;
% xlabel('X(mm)');
% ylabel('Y(mm)'); 
% zlabel('Z(mm)'); 
% axis equal;
% set(gca,'XLim',[-350,-170]);
% set(gca,'XTick',[-350:60:-170]);
% set(gca,'YLim',[-200,100]);
% set(gca,'YTick',[-200:60:100]);
% set(gca,'ZLim',[50,350]);
% set(gca,'ZTick',[50:60:350]);
% set(gca, 'Fontname', 'Times New Roman','FontSize',15);



close(writerObj);
