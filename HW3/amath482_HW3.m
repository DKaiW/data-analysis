clc
clear
close all
testnum=4;
%change the test number here

for cameranum=1:3
%change the different video of 3 camera here
    
regionselect=zeros(480,640);
if cameranum==1
regionselect(:,280:400)=1;
end
if cameranum==2
regionselect(1:400,200:450)=1;
end
if cameranum==3
regionselect(180:320, 250:640)=1;
end
%setting selected region of certain camera

tol=10;
if testnum==1||testnum==2
tol=4;
end
if testnum==3||testnum==4
tol=3;
end

[x,y]=findmloc(testnum,cameranum,regionselect,tol);
%plot x y
figure('Position', [10 10 1800 600])
subplot(1,2,1)
plot(1:length(y),x)
grid on
title('x-t')
subplot(1,2,2)
plot(1:length(y),y)
grid on
title('y-t')

if cameranum==1
   x_a=x;
   y_a=y;
end
if cameranum==2
   x_b=x;
   y_b=y;
end
if cameranum==3
   x_c=x;
   y_c=y;
end
end
%%
%data processing
tmin=min([length(x_a),length(x_b),length(x_c)]);
x_a=x_a(1:tmin);
x_b=x_b(1:tmin);
x_c=x_c(1:tmin);
y_a=y_a(1:tmin);
y_b=y_b(1:tmin);
y_c=y_c(1:tmin);
%since 3 cameras have different recording lengths
%truncate them to same length

XY=[x_a;y_a;x_b;y_b;x_c;y_c];
[U,S,V] = svd(XY,'econ');
X_rank1 = S(1,1)*U(:,1)*V(:,1)';
disp(S)
XY_proj=U'*XY;

figure('Position', [100 200 1300 800])
subplot(1,2,1)
for i=1:6
   plot(1:tmin,XY(i,:),'.','MarkerSize',10) 
   hold on
end
title('raw x,y data from camera')
legend('x_a','y_a','x_b','y_b','x_c','y_c')
subplot(1,2,2)
for i=1:6
   plot(1:tmin,X_rank1(i,:),'.','MarkerSize',10) 
   hold on
end
title('rank 1 approximation')