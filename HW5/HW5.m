clear  
clc

filepath1='ski_drop_low.mp4';
filepath2='monte_carlo_low.mp4';
videodata=VideoReader(filepath2);
%change the filepath here to choose two different video to analyse
Nnum=videodata.Height*videodata.Width;%number of frames

%%

X=zeros(Nnum,videodata.NumFrames);
for i= 1:v
    ideodata.NumFrames


    I=read(videodata,i);
    I=rgb2gray(I);
%     subplot(2,1,1)
%     imshow(I)
%     subplot(2,1,2)
%     imshow(I_low/max(max(I_low)))
%     pause(0.0001)
    uxt=reshape(I,Nnum,1);
    X(:,i)=uxt;
   
end
disp('finish constructing X matrix')
%%
[~ ,S0 ,~]=svd(X,'econ');
singulvalues=diag(S0);
figure(1)
plot(log(singulvalues),'ko')
xlabel('mode num')
ylabel('log of singular value')
title('Singular Value Spectrum')
grid on 
lowrank=find(log(singulvalues)>4,1,'last');
disp('finish SVD analysis of X matrix')
%%
%DMD
[X_DMD,X1]=DMD(X,videodata,lowrank);
disp('finish DMD analysis')
%%
X_sparse=X1-abs(X_DMD);
R = X_sparse.*(X_sparse<0);
X_sparse = X_sparse-R;

%%
sf=200;
I=X(:,sf);
I=reshape(I,540,960);
figure()
subplot(1,3,1)
imshow(uint8(I))
title('Original Video')

I=X_sparse(:,sf);
I=reshape(I,540,960);
subplot(1,3,2)
imshow(imcomplement(uint8(I)*2))
%increase the lightness of foreground by *2
%reverse the image to make the forground image more clear
%as the figure is a dot in ski video
title('X_{sparse}, Foreground')

I=X_DMD(:,sf);
I=reshape(I,540,960);
subplot(1,3,3)
imshow(uint8(I))
title('X_{DMD}, Background')
%%
disp('showing result please wait')
figure()
for i =1:videodata.NumFrames-1
 
    I=X(:,i);
    I=reshape(I,540,960);    
    subplot(1,3,1)
    imshow(uint8(I))
    drawnow
    title('Original Video')
    I=X_sparse(:,i);
    I=reshape(I,540,960);
    subplot(1,3,2)
%     imshow(uint8(I)*1.3)
    imshow(imcomplement(uint8(I)*2))
    drawnow
    title('X_{sparse}, Foreground')
    I=X_DMD(:,i);
    I=reshape(I,540,960);
    subplot(1,3,3)
    imshow(uint8(I))
    drawnow
    title('X_{DMD}, Background')
    disp(['showing frame ',num2str(i),' / ',num2str(videodata.NumFrames)])
end



