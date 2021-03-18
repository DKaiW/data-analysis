close all
clear all
figure(1)
% [y, Fs] = audioread('GNR.m4a');
[y, Fs] = audioread('Floyd.m4a');

% y=y(1:0.2*length(y));%truncate the clip for test convinience
subplot(2,2,[1 3])
plot((1:length(y))/Fs,y);
xlabel('Time [sec]'); ylabel('Amplitude');
title('Sweet Child O Mine');
% p8 = audioplayer(y,Fs); playblocking(p8);
%%
%decrease the resolution of original clip to decrease the data size
%or it will encounter insufficient processing memory
samplerate=10;
sample=1:samplerate:length(y);
y=y(sample);
Fs=Fs/samplerate;

%%
%this part setsignal, frequency domain in same array size, and fft signal
%plot spectrum in signal domain(Hz)
tr_real = length(y)/Fs; % record time in seconds
n=length(y);
L=tr_real;
t2 = linspace(0,L,n+1); 
k = (1/L)*[0:n/2-1 -n/2:-1];
t = t2(1:length(k));
S=y(1:length(k));
ks = fftshift(k);
St=fft(S);
subplot(2,2,2)

plot(ks,abs(fftshift(St))/abs(max(St)))
xlim([0,2000])
xlabel('Frequency [Hz]');
ylabel('fft(S)')
title('Origin Frequency Distribution')
%%
%this part filter the overtones
tau=1e-5;
k0=400;
filter = exp(-tau*(k - k0).^2);
St=St'.*filter;
S=ifft(St);
%use a gaussian filter to fliter out overtones
%from the instruction, instruments' frequency is around middle C,
%so we set the filter's center frequency as 300Hz.
subplot(2,2,4)
plot(ks,abs(fftshift(St))/abs(max(St)))
xlim([0,2000])
xlabel('Frequency [Hz]');
ylabel('fft(S)')
title('Filtered Frequency Distribution')

%%
%use gaussian window function to scale over the song
%to get time-related frequency domain
a=1000;%after comparing different setting of parameter a,
%value 2000 can have a relative promissing result in both time and frequency resolution
tau=0:0.1:tr_real;
i=1;
for j=1:length(tau)
    
    g = exp(-a*(t - tau(j)).^2);
    sg=g.*S;
    sgt=fft(sg);
    sgt_spec(:,j)= fftshift(abs(sgt));
    i=i+1;
    disp(['scaling',num2str(j),'/',num2str(length(tau))])
    figure(2)
    sgtf=fftshift(sgt);
    plot(ks,abs(sgtf)/max(abs(sgtf)))
    xlim([0,2000])
     
    xlabel('Frequency [Hz]');
    ylabel('fft(S)')    
    title('Frequency spectrum during scaling')
    pause(0.001)   
end


%%
%this part plot the spectrogram and add lines of tones
figure('Position', [10 10 2000 800])

% index=find(200<ks<1000);%to find guitar solo,truncate the low frequency
% sgt_spec=sgt_spec()
sgt_spec=log(abs(sgt_spec)+1);
spec=1-(abs(sgt_spec)./max(abs(sgt_spec)));
pcolor(tau,ks(1,0.5*length(ks):length(ks)),spec(0.5*length(ks):length(ks),:))

%truncate the frequency domain in half to save plotting time
ylim([0,1000])
shading interp
colormap(gray)
hold on

%draw line of frequencies in staff system
ctone=[130.8 146.8 164.8 174.8 196.0 220.0 246.9 261.63 293.66 329.63 349.23 392.00 440.00 493.88 523.55 587 659 698 784 880 988];
%frequency of tones from C1
tonename=['C','D','E','F','G','A','B','C','D','E','F','G','A','B','C','D','E','F','G','A','B','C','D','E','F','G'];
for i=1:length(ctone)
    plot([tau(1),tau(end)],[ctone(i),ctone(i)],'-r')
    text(tau(end),ctone(i),tonename(i),'FontSize',10)
    hold on
end

semitone=[277 311 370 415 466 554 622 740 831 932];
%frequency of semitones C1#
tonename2={'C#','D#','F#','G#','A#','C#','D#','F#','G#','A#','C#','D#','F#','G#','A#'};
for i=1:length(semitone)
    plot([tau(1),tau(end)],[semitone(i),semitone(i)],'-b')
    text(tau(end-5),semitone(i),string(tonename2(i)),'FontSize',9)
    hold on
end
title('music score of Comfortably Numb','Fontsize',20)
ylabel('Frequency [Hz]','Fontsize',20);
xlabel('Time [s]','Fontsize',20)

%%
%%
%this part mean to filter around low frequency to issolate the base
S=y(1:length(k));
St=fft(S);
figure(4)
subplot(2,1,1)
plot(ks,abs(fftshift(St))/abs(max(St)))
xlim([0,2000])
xlabel('Frequency [Hz]');
ylabel('fft(S)')
title('Origin Frequency Distribution')
%setting signal, frequency domain in same array size, and fft signal
%plot spectrum in signal domain(Hz)

tau=1e-4;
k0=100;
filter = exp(-tau*(k - k0).^2);
St=St'.*filter;
S=ifft(St);
%as we can see
subplot(2,1,2)
plot(ks,abs(fftshift(St))/abs(max(St)))
xlim([0,2000])
xlabel('Frequency [Hz]');
ylabel('fft(S)')
title('Isolated Base frequnce')

a=1000;%after comparing different setting of parameter a,
%value 2000 can have a relative promissing result in both time and frequency resolution
tau=0:0.1:tr_real;
i=1;
for j=1:length(tau)
    
    g = exp(-a*(t - tau(j)).^2);
    sg=g.*S;
    sgt=fft(sg);
    sgt_spec(:,j)= fftshift(abs(sgt));
    i=i+1;
    disp(['2scaling',num2str(j),'/',num2str(length(tau))])
    figure(11)
    sgtf=fftshift(sgt);
    plot(ks,abs(sgtf)/max(abs(sgtf)))
    xlim([0,2000])
     
    xlabel('Frequency [Hz]');
    ylabel('fft(S)')    
    title('Frequency spectrum of isolated base during scaling')
    pause(0.002)   
end
figure( 'Position', [10 10 2000 400])
% pcolor(tau,ks,sgt_spec)
spec=1-(abs(sgt_spec)./max(abs(sgt_spec)));
pcolor(tau,ks(1,0.5*length(ks):length(ks)),spec(0.5*length(ks):length(ks),:))
%truncate the frequency domain in half to save plotting time
title('isolated base of Comfortably Numb')
ylabel('Frequency [Hz]');
xlabel('Time [s]')
ylim([0,400])
shading interp
colormap(gray)
hold on


%%
disp(['please wait for the plot of spectrogram'])
disp(['finish'])