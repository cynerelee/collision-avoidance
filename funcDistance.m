function [sj,tj,w] = funcDistance(s0,s1,s,rs,t0,t1,t,rt)
%s0和s1为线段L1上的两端点,t0,t1为线段L2上的两端点
%s，t默认最近的点
%   sj、tj为两线段上最近的两点，w为两点间的距离
u=s1-s0;
v=t1-t0;
w0=s0-t0;
a=u*u';
b=u*v';
c=v*v';
d=u*w0';
e=v*w0';
sc=(b*e-c*d)/(a*c-b*b);
tc=(a*e-b*d)/(a*c-b*b);
sj=s0+sc*u;
tj=t0+tc*v;
m=sj;
n=tj;
if a*c-b*b==0
    sj=s;
    tj=t;
end
if sc<=0
    sj=s0;
end
if sc>=1
    sj=s1;
end
if tc<=0
    tj=t0;
end
if tc>=1
    tj=t1;
end
w=norm(sj-tj)-rs-rt;
% plot3([sj(1) tj(1)],[sj(2) tj(2)],[sj(3) tj(3)],'g','LineWidth',3);
% plot3([m(1) n(1)],[m(2) n(2)],[m(3) n(3)],'r','LineWidth',3);
hold on;
end

