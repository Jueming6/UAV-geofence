clear all; 
close all; 

%generate map (boundary, pbstacle)
% W=zeros(300,300);
% W(120:230,120:230)=0;
% W(1:120,1:300)=1;
% W(1:300,1:120)=1;
% W(230:300,1:300)=1;
% W(1:300,230:300)=1;
% WB=W;

end_point =[250;180]; 
start_point = [100;155];
clear options;
options.nb_iter_max = 1e7;
options.end_points = end_point; % stop propagation when end point reached

theta = atan(end_point(1)-start_point(1)/(end_point(2)-start_point(2)));
vUAVT=10;
deA=5;
time=1;
epGPS=2;
l1 = (vUAVT )^2/2/deA;
l2 = (vUAVT )*time + epGPS;
dd1 = l1*sin(theta);
dd2 = l2*sin(theta);

figure(1)
patch([0 0 300 300],[0 300 300 0],'g');
hold on
patch([150 150 200 200],[150-dd1-dd2 150 150 150-dd1-dd2],'y');
hold on
patch([150 150 200 200],[150-dd1 150 150 150-dd1],'r');
hold on
patch([150 150 200 200],[150 200 200 150],'b');

WB=ones(300,300);
WB(fix(150-dd1-dd2):200,150:200)=0;

[D, S, Q] = perform_fast_marching(WB, start_point, options);
 gpath = compute_geodesic(D,end_point);
% 
% %heading angle
% theta=zeros(1,length(gpath(1,:)));
% for i = length(gpath(1,:))-1 :-1:1
%     theta(i) = atan(gpath(1,i+1)-gpath(1,i))/(gpath(2,i+1)-gpath(2,i));
% end
% theta0=max(theta);
% vUAVT=10;
% deA=5;
% time=1;
% epGPS=2;
% l1 = (vUAVT )^2/2/deA;
% l2 = (vUAVT )*time + epGPS;
% dd = (l1 + l2)*sin(theta0);
%
figure(2)
contourf(WB)
% patch([0 0 300 300],[0 300 300 0],'g');
% hold on
% patch([150 150 200 200],[120 230 230 120],'r');
% hold on
% patch([120 120 230 230],[120 230.5 230.5 120],'y');
% hold on
% patch([150 150 200 200],[150 200 200 150],'b');
hold on
plot(gpath(2,:), gpath(1,:), 'k-', 'linewidth', 3)
title('Shortest path');


