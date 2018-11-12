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
nn=1;
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
figure(1)
patch([0 0 xx xx],[0 yy yy 0],'g');
hold on
patch([0 0 xx xx],[yy yy+geofence1 yy+geofence1 yy],'r');
hold on
patch([0 0 xx xx],[yy+geofence1 yy+geofence1+100 yy+geofence1+100 yy+geofence1],'b');


%uav velocity logN
% m = 16.5;
% v = 4.6;
% mu = log((m^2)/sqrt(v+m^2));
% sigma = sqrt(log(v/(m^2)+1));
vvv=[8.9 20 18 24.6 17.9 18 10.3 15.6 13.8 17.9].';
parmhat = lognfit(vvv);
%uav deA logN
vvvvv=[5.4 8.7 3.2 3.2 4.9 6.7 1.8].';
parmhat2 = lognfit(vvvvv);
NN = 10;
dd = zeros(1,NN);
l1 = zeros(1,NN);
l2 = zeros(1,NN);
p0 = zeros(2,NN);
pp = p0;
time = zeros(1,NN);
vWind = zeros(1,NN);
vUAV = zeros(1,NN);
deA = zeros(1,NN);
vwind0 = zeros(1,2);
F=0;
for i = 1:NN
%GPS updating frequency   time: uniform
    time(i) = 2*rand(1);
%wind velocity weibull 2.86,2.2
    vwind0(1)=wblrnd(2.86,2.2,1,1);
    vwind0(2)=-vwind0(1);
    vWind(i) = vwind0(randi([1 2]));
    %-10+20*rand(1);
%UAV velocity  ??? mu,sigma
    vUAV(i) = lognrnd(parmhat(1),parmhat(2),1,1);
%GPS error: Norm()
    epGPS(i) = -1.5+3*rand(1);
% controllable safe distance(deA: logN)  l1
    deA(i) = lognrnd(parmhat2(1),parmhat2(2),1,1);
    l1(i) = (vUAV(i) + vWind(i))^2/2/deA(i);
% error distance l2
    l2(i) = (vUAV(i) + vWind(i))*time(i) + epGPS(i);
%geofence
    dd(i) = l1(i) + l2(i);
%flight
    p0(1,i) = xx*rand(1);
    pp(1,i) = p0(1,i);
    p0(2,i) = yy*rand(1);
    pp(2,i) = p0(2,i)+(fix((yy-p0(2,i))/(vUAV(i) + vWind(i))/time(i))+1)*(l2(i)-epGPS(i))+epGPS(i)+l1(i);
    if pp(2,i) > yy+geofence1
        F=F+1;
    end
end
F
xlabel('map x')
ylabel('map y')
%axis([0 100 0 yy+nn*geofence+100])
axis([0 100 0 yy+geofence1+100])
scatter(p0(1,:),p0(2,:),'*');
hold on
scatter(pp(1,:),pp(2,:),'o','y');

% figure(2)
% [a,b]=hist(dd,40);
% bar(b,a/NN);
% a/NN
% b

%     Y = geofence+yy+100;
% N = round(Y/(vWind + vUAV)+(vWind + vUAV)/deA);
% pp = zeros(2, N);
% pp(1,1:end) = p0(1);
% pp(2,1) = p0(2);
% ttt= (vUAV + vWind)/deA;
% for i = 1:length(pp)-1
%     if pp(2,i) < 100
%         pp(2,i+1) = pp(2,i) + (vUAV + vWind)*time + epGPS;
%     else
%         if vUAV > 0 && vUAV - deA*time >=0
%             pp(2,i+1) = pp(2,i) + (vUAV + vWind)*time - 0.5*deA*time^2 + epGPS;
%             vUAV = vUAV - deA*time
%         else
%             if vUAV > 0 && vUAV - deA*time <0
%                 pp(2,i+1) = pp(2,i) + (vUAV + vWind)^2/2/deA + epGPS;
%                 break;
%             end
%         end        
%     end
%     if pp(2,i+1) >= geofence+yy
%         %pp(2,i+1) = 0;
%         break;
%     end
% end


        