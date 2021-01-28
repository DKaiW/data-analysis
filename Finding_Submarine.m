% Clean workspace
% clear all; close all; clc
close all
load subdata.mat % Imports the data as the 262143x49 (space by time) matrix called subdata

L = 10; % spatial domain
n = 48; % Fourier modes
%

k = (2*pi/(2*L))*[0:(n/2 - 1) -n/2:-1]; %frequency components
ks = fftshift(k);
%%
%this part mean to average the frequency spectrum and get the signature
%frequency
datasize=size(subdata);
ave=zeros(1,n);
 for locate=1:datasize(1)
% for locate=1:5
u=subdata(locate,1:n);%each point time domain
ut=fft(u);%frequency domain
ave=ave+ut;

 end
ave=abs(fftshift(ave))/datasize(1);
figure(1)
plot(ks,ave/max(ave),'r-')
title('Averaged Frequency Spectrum')
%%
%this part adopt a Gaussian filter to decrease the white noise
tau=0.2;
k0=-0.6283;%from above plot, we can see the signature frequency is at 0.6283
k = (2*pi/L)*[0:(49/2 - 1) -49/2:-1];
filter= exp(-tau*(k - k0).^2);

unf=zeros(datasize(1),48);
for locate=1:datasize(1)
u=subdata(locate,1:48);
ut=fft(u);
unft=filter.*ut;
unf(locate,:)=ifft(unft);
end

%%
%plot the original sound field
nn=64;%spacial domain
x2 = linspace(-L,L,nn+1); x = x2(1:nn); y =x; z = x;
[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(ks,ks,ks);

figure(2)
for j=1:49
Un(:,:,:)=reshape(subdata(:,j),nn,nn,nn);
M = max(abs(Un),[],'all');
isosurface(X,Y,Z,abs(Un)/M,0.5)
axis([-20 20 -20 20 -20 20]), grid on, drawnow
pause(0.01)
title("unfiltered noise track")
end

%%
%plot the filtered sound field and get the projection of submarine location
%on X-Y plane
figure(3)
noisesum=zeros(64,64,64);
topox=zeros(1,48);
topoy=zeros(1,48);
for j=1:48
% for j=1
Un(:,:,:)=reshape(unf(:,j),nn,nn,nn);

M = max(abs(Un),[],'all');
isosurface(X,Y,Z,abs(Un)/M,0.5)
noisesum=noisesum+abs(Un)/M;
axis([-20 20 -20 20 -20 20]), grid on, drawnow
pause(0.01)
title("filtered noise track")
ztopo=sum(abs(Un)/M,3);%to get the projection of noise on XY plane.
ztopo=ztopo/max(max(ztopo));
[topox(j),topoy(j)]=find(ztopo==1);
end
figure()
plot(topoy*20/64-10,topox*20/64-10,'Linewidth',3)
%*20/64 mean to transfer 64x64 space in to 20*20,-10 mean to move the
%cordinate center to the corner of the square space
axis([-20 20 -20 20])
title('the projected travel path of submarine in X-Y plain')
%% 
%to generate the coordinates table
tablename={'x coodinate','y coordinate'};
table(topox',topoy','VariableNames',tablename)