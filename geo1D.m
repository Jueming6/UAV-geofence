close all
clear all

%define geofence
% aveTime = 1;
% aveVuav = 9.5;
% aveVwind = 0;
% aveEgps = 0;
% aveDea = 5.865;
% ll1 = (aveVuav+aveVwind)*aveTime + aveEgps;
% ll2 = 0.5*(aveVuav+aveVwind)^2/aveDea;

xx=100;
yy=50;
%geofence = (aveVuav+aveVwind)*aveTime + aveEgps + 0.5*(aveVuav+aveVwind)^2/aveDea;
% figure(1)
% patch([0 0 xx xx],[0 yy yy 0],'g');
% hold on
% patch([0 0 xx xx],[yy yy+nn*ll1 yy+nn*ll1 50],'y');
% hold on
% patch([0 0 xx xx],[yy+nn*ll1 yy+nn*geofence yy+nn*geofence yy+nn*ll1],'r');
% hold on
% patch([0 0 xx xx],[yy+nn*geofence yy+nn*geofence+100 yy+nn*geofence+100 yy+nn*geofence],'b');
% hold on
geofence1=30;
% figure(1)
% patch([0 0 xx xx],[0 yy yy 0],'g');
% hold on
% patch([0 0 xx xx],[yy yy+geofence1 yy+geofence1 yy],'r');
% hold on
% patch([0 0 xx xx],[yy+geofence1 yy+geofence1+100 yy+geofence1+100 yy+geofence1],[0.75 0.75 0.75]);


%uav velocity logN
vvv=[18 16 20 3 8 14 13.9].';
parmhat = lognfit(vvv);
%uav deA logN
vvvvv=[5.4 8.7 3.2 3.2 4.9 6.7 1.8].';
parmhat2 = lognfit(vvvvv);
NN = 100000;

dd1=zeros(1,NN);

dd = zeros(1,NN);
l1 = zeros(1,NN);
l2 = zeros(1,NN);
p0 = zeros(2,NN);
pp = p0;
time = zeros(1,NN);
vWind = zeros(1,NN);
vUAV = zeros(1,NN);
deA = zeros(1,NN);
nn = zeros(1,NN);
vwind0 = zeros(1,2);
F=0;
sum=0;
area = zeros(1,NN);

dd2 = zeros(1,NN);
l12 = zeros(1,NN);
l22 = zeros(1,NN);
time2 = zeros(1,NN);
vWind2 = zeros(1,NN);
vUAV2 = zeros(1,NN);
deA2 = zeros(1,NN);
nn = zeros(1,NN);
vwind02 = zeros(1,2);    
%case1

for i = 1:NN
%GPS updating frequency   time: uniform
    time1(i) = 2*rand(1);
%wind velocity weibull 2.86,2.2
    vwind01(1)=wblrnd(2.86,2.2,1,1);
    vwind01(2)=-vwind01(1);
    vWind1(i) = vwind01(randi([1 2]));
    %-10+20*rand(1);
%UAV velocity  ??? mu,sigma
    vUAV1(i) = 3+17*rand(1); 
%GPS error: Norm()
    epGPS1(i) = -1.5+3*rand(1);
% controllable safe distance(deA: logN)  l1
    deA1(i) = 3.2+3.5*rand(1); 
    l11(i) = (vUAV1(i) + vWind1(i))^2/2/deA1(i);
% error distance l2
    l21(i) = (vUAV1(i) + vWind1(i))*time1(i);
%geofence
    dd1(i) = abs(l11(i) + abs(l21(i))+ epGPS1(i));
    
%flight
    p0(1,i) = xx*rand(1);
    pp(1,i) = p0(1,i);
    p0(2,i) = yy*rand(1);
    if (vUAV(i) + vWind(i))>0
        nn(i)=fix((yy-p0(2,i))/(vUAV(i) + vWind(i))/time(i))+1;
        pp(2,i) = p0(2,i)+nn(i)*l2(i)+epGPS(i)+l1(i);
        if pp(2,i) > yy+geofence1
           F=F+1;
        end
    end
%     area(i)=pi*epGPS(i)^2+2*epGPS(i)*(abs(l2(i))+l1(i));
%     sum=sum+abs(area(i));
%     if sum > 1*1000*1*1000;
%         break;
%     end
%     
end

% [a,b]=hist(dd,50);
% bar(b,a/NN);
parmhat1 = lognfit(dd1);

y1 = lognpdf(0:1:120,parmhat1(1),parmhat1(2))
plot(0:1:120,y1)

hold on

%case 2
for i = 1:1
%GPS updating frequency   time: uniform
    
%wind velocity weibull 2.86,2.2
    vwind02(1)=wblrnd(2.86,2.2,1,1);
    vwind02(2)=-vwind02(1);
    vWind2(i) = vwind02(randi([1 2]));
    %-10+20*rand(1);
%UAV velocity  ??? mu,sigma
    vUAV2(i) = 11.5; 

%GPS error: Norm()
for j=1:NN
    time2(j) = 2*rand(1);
    deA2(j) = 3.2+3.5*rand(1); 
    epGPS2(j) = -1.5+3*rand(1);
% controllable safe distance(deA: logN)  l1
    l12(j) = (vUAV2(i) + vWind2(i))^2/2/deA2(j);
% error distance l2
    l22(j) = (vUAV2(i) + vWind2(i))*time2(j);
%geofence
    dd2(j) = abs(l12(j) + abs(l22(j))+ epGPS2(j));
end
end
parmhat = lognfit(dd2);

y2 = lognpdf(0:1:60,parmhat(1),parmhat(2))
plot(0:1:60,y2)
hold on

%case3
for i = 1:1
%GPS updating frequency   time: uniform
    
%wind velocity weibull 2.86,2.2
    vwind0(1)=wblrnd(2.86,2.2,1,1);
    vwind0(2)=-vwind0(1);
    vWind(i) = vwind0(randi([1 2]));
    %-10+20*rand(1);
%UAV velocity  ??? mu,sigma
    vUAV(i) = 11.5; 
    time(i) = 2*rand(1);
    deA(i) = 3.2+3.5*rand(1); 
%GPS error: Norm()
for j=1:NN

    epGPS(j) = -1.5+3*rand(1);
% controllable safe distance(deA: logN)  l1
    l1(j) = (vUAV(i) + vWind(i))^2/2/deA(i);
% error distance l2
    l2(j) = (vUAV(i) + vWind(i))*time(i);
%geofence
    dd(j) = abs(l1(j) + abs(l2(j))+ epGPS(j));
end
end
parmhat3 = lognfit(dd);

y3 = lognpdf(0:1:40,parmhat3(1),parmhat3(2))
plot(0:1:40,y3)

xlabel('Geofence Size(m)');
ylabel('Probability');
title('Distribution of Geofence Size');
legend('Static geofence with 1% failure','Dynamic geofence with known UAV & wind velocities','Proposed dynamic geofence');
