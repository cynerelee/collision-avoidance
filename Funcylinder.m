function [s1] = Funcylinder(p,q,r)
%p为下端点，q为上端点，r为圆柱半径
% circle为圆柱体侧面上点构成的矩阵

global yuan
yuan=imread('yuan.bmp');
theta=0:2*pi/64:2*pi;
i=1:length(theta);
t=i/length(theta);
pq=-(p-q)/norm(p-q);
l=norm(p-q);
%s1=p+pq*l;
XYZ=p+t'*pq*l;
j=cross(pq,[1 0 0]);%cross计算两个向量的叉乘,该向量垂直于这两个向量构成的法平面
j=j/norm(j);
k=cross(pq,j);
k=k/norm(k);
circle=zeros(length(theta),length(theta),3);
for i=1:length(theta)
    xyz=repmat(XYZ(i,:),length(theta),1);
    circle(i,:,:)=xyz+r*cos(theta)'*j+r*sin(theta)'*k;

end
% plot3(p(1),p(2),p(3),'*','MarkerSize',10);
% hold on
% plot3(q(1),q(2),q(3),'o','MarkerSize',10);
%  plot3(s1(1),s1(2),s1(3),'*','MarkerSize',10);
%  hold on;
    b=surf(circle(:,:,1),circle(:,:,2),circle(:,:,3),double(yuan));
% colormap Gray;
set(b,'linestyle','none'); 
end