function newpath=winderror(w,path,kk,N)
newpath = path;
% close all
% clear all
% N=2;
% kk=[3,5];
% path(1,:,:)=[0,1,2,0,0;
%              0,1,2,0,0];
% path(2,:,:)=[0,1,2,3,4;
%              0,2,3,6,6];
newpath = path;
% w=[-2,2];
for i = 1:N
    for j = 2:kk(i)
        %v: vector between n point in planned trajectory and n-1 actual
        %point
          v = [path(i,2,j)-newpath(i,2,j-1), path(i,1,j)-newpath(i,1,j-1)];
          w1 = (dot(w,v)/norm(v)^2)*v;
          %ww: vector that afftect direction of trajectory
          ww = w-w1;
          newpath(i,2,j) = path(i,2,j)+ww(1);
          newpath(i,1,j) = path(i,1,j)+ww(2);
    end
end
% for j=1:N
%     for i = 1: kk(j)
%         aa(j,i) = newpath(j,2,i);
%         b(j,i) = newpath(j,1,i);
%         aa0(j,i) = path(j,2,i);
%         b0(j,i) = path(j,1,i);
%     end
% end
% plot(aa(1,1:kk(1)),b(1,1:kk(1)));
% hold on 
% plot(aa(2,1:kk(2)),b(2,1:kk(2)));
% hold on 
% plot(aa0(1,1:kk(1)),b0(1,1:kk(1)));
% hold on 
% plot(aa0(2,1:kk(2)),b0(2,1:kk(2)));
% legend('new1','new2','1','2')
% xlim([-5,8])
% ylim([-5,8])