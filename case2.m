%2Dcase2
close all
clear all

%dji v
vvv=[18 16 20 3 8 14 13.9].';
parmhat = lognfit(vvv);
%dji a
vvvvv=[5.4 8.7 3.2 3.2 4.9 6.7 1.8].';
parmhat2 = lognfit(vvvvv);

N=30000;
NN = 1000;
dd = zeros(1,NN);
l1 = zeros(1,NN);
l2 = zeros(1,NN);
p0 = zeros(2,NN);
pp = p0;
time = zeros(1,NN);
vWind = zeros(1,N);
vUAV = zeros(1,N);
deA = zeros(1,NN);
nn = zeros(1,NN);
vangle = zeros(1,N);
vwind0 = zeros(1,2);
D=zeros(1,N);
sum1=0;
NNN=100;
sum2=0;
ddp=zeros(1,NN);
ddh=zeros(1,NN);
for jj=1:NNN
    
for j = 1:N
    %UAV velocity U
    vUAV(j) = 3+17*rand(1); 
    %wind velocity weibull 2.86,2.2
    vwind0(1)=wblrnd(2.86,2.2,1,1);
    vwind0(2)=-vwind0(1);
    vWind(j) = vwind0(randi([1 2]));
    vangle(j)=2*pi*rand(1);
    vwindh(j)=vWind(j)*cos(vangle(j));
    vwindp(j)=vWind(j)*sin(vangle(j));
    for i=1:NN
%GPS updating frequency   time: uniform
        time(i) = 2*rand(1);

%GPS error: U
        epGPS(i) = -1.5+3*rand(1);
% controllable safe distance(deA: U)  l1
        deA(i) = 3.2+3.5*rand(1); 
        l1(i) = (vUAV(j) + vwindh(j))^2/2/deA(i);
% error distance l2
        l2(i) = (vUAV(j) + vwindh(j))*time(i);
%geofence
        ddh(i)=abs(l1(i) + abs(l2(i))+ epGPS(i));
        ddp(i)=abs(vwindp(j)^2/2/deA(i)+abs(vwindp(j))*time(i)+epGPS(i));
        dd(i) = max(ddh(i),ddp(i));
    end
    [a,b]=hist(dd,40);
    for k= length(a):-1:1
        sum1=sum1+a(k)/NN;
        if sum1>=0.01
            D(j)=b(k);
            sum1=0;
            break;
        end
    end
    sum2=sum2+pi*D(j)^2;
    if sum2>=1000*1000
        num(jj)=j-1;
        sum2=0;
        break;
    end
end
    
end
