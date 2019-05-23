clc
clear all
close all
% screensize =get(0, 'Screensize'); %older version
screensize = get( groot, 'Screensize' );
% screensize(3)=screensize(3)-20;
% screensize(4)=screensize(4)-20;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


load('btBusData.noHeader.csv-001.txt_float.mat')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NextStop=one_patch(:,1);%NextStop      : float  1076 2090 2301 1312 1041 1408 2315 1109 3141 1151 ..
LineNr=one_patch(:,2);%LineNr   : float  6 23 600 4 1 5 22 12 311 500 .
Delay=one_patch(:,4);%Delay   : float  31 254 35 25 66 162 208 47 403 199 .
LastReport=one_patch(:,5);%LastReport    : float (epoch seconds, since 1900) 1.51e+09 1.51e+09 1.51e+09 1.51e+09 ..
UnitId=one_patch(:,7);%UnitId  : float  101222 101214 101260 100458 101204 100461 101208 101270 101233 101252 ..
TripNr=one_patch(:,9);%TripNr  : float  41 31 20 53 98 42 29 14 27 10 ..
Latitude=one_patch(:,8);%Latitude      : float  56.2 56.2 56.2 56.3 56.2 ...
Longitude=one_patch(:,3);%Longitude     : float  15.7 15.3 15.5 15.6 15.6 ...


tu=find(UnitId==101226 & TripNr==44 & LineNr==6)
lat=Latitude(tu);
length(lat);
lon=Longitude(tu);
length(lon);
timeInterval=diff(LastReport(tu));
max_timeInterval=max(timeInterval);
normalization=(timeInterval/max_timeInterval)
% figure,hist(normalization)
%%%%%%%%%%%%%%%%%%%%
l=cumsum(timeInterval);
figure,plot(timeInterval,'LineWidth',2),
title('Time delay in each rapporting','FontSize',12,'FontWeight','bold','Color','k'),
xlabel('Index of rapporting oppertunity','FontSize',12,'FontWeight','bold','Color','k'),
ylabel('Time in seconds','FontSize',12,'FontWeight','bold','Color','k'),
set(gca,'FontSize',14,'FontWeight','bold','Color','k'),
set(gcf, 'Position', screensize);
pause,
%%%%%%%%%%%%%%%%%%%%%%%%
[bins,p,w]=acNhist2(normalization);
pd = fitdist(normalization,'Exponential');  
x_values = 0:w:max(bins);
y = pdf(pd,x_values);
figure,plot(bins,p,'y','LineWidth',2),grid minor
title('Normalized delay distribution')
xlabel('Normalized delay time','FontSize',12,'FontWeight','bold','Color','k'),
ylabel('Number of occurence','FontSize',12,'FontWeight','bold','Color','k'),
set(gca,'FontSize',14,'FontWeight','bold','Color','k'),
set(gcf, 'Position', screensize);
pause,
%%%%%
figure,plot(bins,p,'y','LineWidth',2),grid minor,hold on,
plot(x_values,y,'r','LineWidth',2);
title('Modelling of delay distribution')
xlabel('Normalized delay time','FontSize',12,'FontWeight','bold','Color','k'),
ylabel('Pdf','FontSize',12,'FontWeight','bold','Color','k'),
set(gca,'FontSize',14,'FontWeight','bold','Color','k'),
set(gcf, 'Position', screensize);
pause,
%%%%%%%%%%%%%%%%%%%%%%%
total_timeInterval=sum(timeInterval);%total time of reporting at all stations in a trip
expected_time_reporting=total_timeInterval/length(timeInterval);%time at which the bus is expected to report to the reporting station,it reports at equal intervals
if timeInterval==expected_time_reporting
    disp("the bus is reporting at equal intervals")
else
    disp("the bus is not reporting at equal intervals")
end
figure,plot(l,'LineWidth',2),
xlabel('Index of rapporting oppertunity','FontSize',12,'FontWeight','bold','Color','k'),
ylabel('Accumulated time in seconds','FontSize',12,'FontWeight','bold','Color','k'),
title('Accumulated time of rapporting process')
set(gca,'FontSize',14,'FontWeight','bold','Color','k'),
set(gcf, 'Position', screensize);
pause,
%%%%%%%%%%%%%
timeV=ones(length(timeInterval),1);
for kk=1:length(timeInterval)%loop for placing the expected values in a new array
    timeV(kk)=timeV(kk)*expected_time_reporting;
end
n=cumsum(timeV);
figure,plot(n,'LineWidth',2),
xlabel('Index of rapporting oppertunity','FontSize',12,'FontWeight','bold','Color','k'),
ylabel('Accumulated time in seconds','FontSize',12,'FontWeight','bold','Color','k'),
title('Expected accumulated time of rapporting process')
set(gca,'FontSize',14,'FontWeight','bold','Color','k'),
set(gcf, 'Position', screensize);
pause,
%%%%%%%%%%
length(timeV);%finding the array length of expected_time_reporting
actual_diff_reporting=(timeV-timeInterval);%finding the delay between the actual bus reporting times and where the bus is expected to report
length(actual_diff_reporting);

InitTime=0;%intial value of array is equal to zero
timeZ=ones(length(timeInterval)+1,1);
timeZ(1)=InitTime;
for nn=1:length(timeInterval+1)
    timeZ(nn+1)=timeZ(nn)+timeV(nn);
end
a=cumsum(timeZ);
timeX=zeros(length(timeInterval)+1,1);
timeX(1)=InitTime;
for jj=1:length(timeInterval+1)
    timeX(jj+1)=timeX(jj)+timeInterval(jj);
end
figure,plot(timeX,'r','LineWidth',2),
hold on
plot(timeZ,'b','LineWidth',2)

xlabel('Index of rapporting oppertunity','FontSize',12,'FontWeight','bold','Color','k'),
ylabel('Accumulated time in seconds','FontSize',12,'FontWeight','bold','Color','k'),
title('Expected  vs actual accumulated time of rapporting process','FontWeight','bold','Color','k'),
set(gca,'FontSize',14,'FontWeight','bold','Color','k'),
set(gcf, 'Position', screensize);
pause,
%%%%%%%%%%%%%%%%%%%%
average1=mean(timeInterval);%mean of uneven reporting time of the bus
average2=mean(actual_diff_reporting);%mean of expected reporting time

length(timeX);

e=timeX-timeZ;%difference between actual and expected reporting time of the bus
e=e-min(e); 

figure,plot(e,'LineWidth',2),
title('Time delay in each rapporting','FontSize',12,'FontWeight','bold','Color','k'),
xlabel('Index of rapporting oppertunity','FontSize',12,'FontWeight','bold','Color','k'),
ylabel('Time in seconds','FontSize',12,'FontWeight','bold','Color','k'),
set(gca,'FontSize',14,'FontWeight','bold','Color','k'),
set(gcf, 'Position', screensize);
pause,
%%%%%%%%%%%%%%
[bins,p,w]=acNhist2(e);

figure,plot(bins,p,'y','LineWidth',2),grid minor
title('Normalized delay distribution')
xlabel('Normalized delay time','FontSize',12,'FontWeight','bold','Color','k'),
ylabel('Number of occurence','FontSize',12,'FontWeight','bold','Color','k'),
set(gca,'FontSize',14,'FontWeight','bold','Color','k'),
set(gcf, 'Position', screensize);
pause,
%%%%%
figure,plot(bins,p,'y','LineWidth',2),
hold on,

pd1 = fitdist(e,'normal');
x_values = 0:w:max(bins);
y1 = pdf(pd1,x_values);
plot(x_values,y1,'r','LineWidth',2);

pd2 = fitdist(e,'Kernel','Kernel','normal');
x_values = 0:w:max(bins);
y2 = pdf(pd2,x_values);
plot(x_values,y2,'g','LineWidth',2);

pd3 = fitdist(e,'Rayleigh');
y3 = pdf(pd3,x_values);
plot(x_values,y3,'c','LineWidth',2);

legend('Sampled','Gaussian','Kernel-normal','Rayleigh','FontSize',12,'TextColor','white'),legend('boxoff')

title('Modelling of delay distribution')
xlabel('Normalized delay time','FontSize',12,'FontWeight','bold','Color','k'),
ylabel('Pdf','FontSize',12,'FontWeight','bold','Color','k'),
set(gca,'FontSize',14,'FontWeight','bold','Color','k'),
set(gcf, 'Position', screensize);
ax = gca;
grid minor, ax.MinorGridColor ='w';
pause,
%%%%%%%%%%%%%%%%%%%%%%%%
normalization=timeInterval/max(timeInterval);
normalization=[0;normalization];
a=colormap(jet(length(lat)));
% close(gcf)

b=sort(normalization);
colorVector=zeros(length(lon) - 1,3);
for k=1:length(normalization)
    tp=find(b==normalization(k));
    colorVector(k,:)=a(tp(1),:);
end

figure,hold on

for i = 1 : length(lon) - 1
%   line('XData', lon(i:i+1), 'YData', lon(i:i+1), 'LineWidth',4,'Color', colorVector(i, :));
  plot([lon(i),lon(i+1)],[lat(i),lat(i+1)], 'LineWidth',4,'Color', colorVector(i, :));
end
hold on
plot_google_map('MapScale', 2)
axis('off')
colormap jet
c=colorbar;
c.Label.String = 'Communication Delay';
c.Label.FontSize = 12;
c.Label.FontWeight = 'bold';
set(gcf, 'Position', screensize);






