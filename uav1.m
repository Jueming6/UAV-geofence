clear all; 
close all; 
clc;

%generate map (boundary, pbstacle)
W=zeros(300,300);
W(120:230,120:230)=0;
W(1:120,1:300)=1;
W(1:300,1:120)=1;
W(230:300,1:300)=1;
W(1:300,230:300)=1;
WB=W;

%monte carlo
N=2;
end_point=zeros(N,2);
start_point=zeros(N,2);
kk=zeros(1,N);
for i = 1:N
    %generate start, end point (uniformly) ???
     end_point(i,:) = round(230+70*rand(2,1));
     start_point(i,:) = round(120*rand(2,1));
     clear options;
     options.nb_iter_max = 1e7;
     options.end_points = transpose(end_point(i,:)); % stop propagation when end point reached
     
     [D, S, Q] = perform_fast_marching(WB, transpose(start_point(i,:)), options);
     gpath = compute_geodesic(D,end_point(i,:));
     kk(i) = length(gpath(2,:));
     if i == 1
         GPATH0 = gpath;
         GPATH = zeros(N,2,kk(i));
         GPATH(1,:,1:kk(i)) = GPATH0;
     end
     
     if i > 1 
         if kk(i) >= max(kk(1:i-1))
             a=GPATH(1:i-1,:,:);
             ll=length(GPATH(1,1,:));
             GPATH = zeros(N,2,kk(i));
             GPATH(1:i-1,:,1:ll) = a;
             GPATH(i,:,:) = gpath;
         else
             GPATH(i,:,1:kk(i)) = gpath;
         end
     end
         
end

%wind
wind=[-20,20];
newpath=winderror(wind,GPATH,kk,N);


contourf(W)
hold on;
for j=1:N
    for i = 1: kk(j)
        aa(j,i)=GPATH(j,2,i);
        b(j,i)=GPATH(j,1,i);
        aa1(j,i)=newpath(j,2,i);
        b1(j,i)=newpath(j,1,i);
    end
end
plot(aa(1,1:kk(1)),b(1,1:kk(1)), 'r-', 'linewidth', 3)
hold on
plot(aa(2,1:kk(2)),b(2,1:kk(2)), 'r-', 'linewidth', 3)
hold on
plot(aa1(1,1:kk(1)),b1(1,1:kk(1)), 'g-', 'linewidth', 3)
hold on
plot(aa1(2,1:kk(2)),b1(2,1:kk(2)), 'g-', 'linewidth', 3)
legend('planned trajectory1','planned trajectory2','actual1','actual2')
%title('Shortest path');
