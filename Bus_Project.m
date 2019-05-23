clc
clear all
close all

load btBusData.noHeader.csv-000.txt_float.mat

NextStop=one_patch(:,1);%NextStop      : float  1076 2090 2301 1312 1041 1408 2315 1109 3141 1151 ..
LineNr=one_patch(:,2);%LineNr   : float  6 23 600 4 1 5 22 12 311 500 .
Delay=one_patch(:,4);%Delay   : float  31 254 35 25 66 162 208 47 403 199 .
LastReport=one_patch(:,5);%LastReport    : float (epoch seconds, since 1900) 1.51e+09 1.51e+09 1.51e+09 1.51e+09 ..
UnitId=one_patch(:,7);%UnitId  : float  101222 101214 101260 100458 101204 100461 101208 101270 101233 101252 ..
TripNr=one_patch(:,9);%TripNr  : float  41 31 20 53 98 42 29 14 27 10 ..
Latitude=one_patch(:,8);%Latitude      : float  56.2 56.2 56.2 56.3 56.2 ...
Longitude=one_patch(:,3);%Longitude     : float  15.7 15.3 15.5 15.6 15.6 ...


tu=find(UnitId==101222 & TripNr==41 & LineNr==6);
lat=Latitude(tu);
length(lat)
lon=Longitude(tu);
length(lon)
timeInterval=diff(LastReport(tu))
max_timeInterval=max(timeInterval)
normalization=(timeInterval/max_timeInterval)
figure,hist(normalization)

l=cumsum(timeInterval);
figure,plot(timeInterval),title('difference of uneven reporting of the bus')
total_timeInterval=sum(timeInterval)%total time of reporting at all stations in a trip
expected_time_reporting=total_timeInterval/length(timeInterval)%time at which the bus is expected to report to the reporting station,it reports at equal intervals
if timeInterval==expected_time_reporting
    disp("the bus is reporting at equal intervals")
else
    disp("the bus is not reporting at equal intervals")
end
figure,plot(l),xlabel('number of reporting stations'),ylabel('uneven reporting time of the bus'),title('reporting time vs number of stations of a bus from btBusData.noHeader.csv-000 data')
scotts_formula_value=3.49*std(timeInterval)/length(timeInterval)^(1/3)%using the scott's formula
no_of_bins = ceil((max(timeInterval) - min(timeInterval))/scotts_formula_value)%calculating the number of bins required using scott's formula
figure,histogram(timeInterval,no_of_bins,'Normalization','pdf'),title('Histogram of time interval of reporting using scotts formula')



timeV=ones(length(timeInterval),1);
for kk=1:length(timeInterval)%loop for placing the expected values in a new array
    timeV(kk)=timeV(kk)*expected_time_reporting;
end
n=cumsum(timeV);
figure,plot(n),xlabel('number of reporting stations'),ylabel('even reporting time'),title('time where bus is expected to report')

length(timeV);%finding the array length of expected_time_reporting
actual_diff_reporting=(timeV-timeInterval)%finding the delay between the actual bus reporting times and where the bus is expected to report
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


average1=mean(timeInterval)%mean of uneven reporting time of the bus
average2=mean(actual_diff_reporting)%mean of expected reporting time

length(timeX);
figure,plot(timeX,'r'),xlabel('number of reporting stations'),ylabel('reporting time in seconds'),title('expected reporting vs actual reporting of bus from btBusData.noHeader.csv-000 data')
hold on
plot(timeZ,'b')
e=abs(timeX-timeZ)%difference between actual and expected reporting time of the bus
norm_e=(e/max(e));
figure,hist(norm_e)
scotts_formula1=3.49*std(e)/length(e)^(1/3);%using the scott's formula
no_of_bins1 = ceil((max(e) - min(e))/scotts_formula1);%calculating the number of bins required using scott's formula
mean(e)%mean difference between actual and expected reporting time of the bus
figure,hist(e,no_of_bins1),title('histogram of difference between expected and actual reporting times')
a=xcorr(e-mean(e),1,'coeff')%it tells us wether the difference in delays at each point are independent or not
if a <0.5
    disp('the consecutive delays in reporting a bus are not correlated ')
    disp('the delays are independent from its previous value')
elseif a==1
    disp('the consecutive delays in reporting a bus are highly correlated ')
    disp('the delays are not independent from its previous value')
else
    disp('the consecutive delays in reporting a bus are correlated ')
    disp('the delays are not independent from its previous value')
end

l=corr(timeX,timeZ)
disp('"l" shows us the value of correlation between the uneven reporting times of bus and the delay')
if l>0.5
    disp('there is high correlation between the uneven reporting times of bus and the delay')
else 
    disp('there is less correlation between the uneven reporting times of bus and the delay')
end
figure,plot(e),xlabel('number of reporting stations'),ylabel('difference of expected and actual reporting times'),title('bus data of btBusData.noHeader.csv-000')
[h f]=chi2gof(e)%chi-square test 
if h==1
    disp('it has rejected the null hypothesis at 5% significance level that its normally distributed')
else
    disp('it has failed to reject null hypothesis')
end
a=colormap(jet)
figure
plot(lon,lat,'color',a(50,:),'LineWidth',3)
hold on
for i=1:length(lon)-1
    if normalization(i)<0.1
        k=1
        plot([lon(i),lon(i+1)],[lat(i),lat(i+1)],'color',a(k,:),'LineWidth',2 )
        hold on
    elseif normalization(i)<0.2
        k=7
        plot([lon(i),lon(i+1)],[lat(i),lat(i+1)],'color',a(k,:),'LineWidth',2 )
        hold on
    elseif normalization(i) < 0.3
        k=15
        plot([lon(i),lon(i+1)],[lat(i),lat(i+1)],'color',a(k,:),'LineWidth',2 )
        hold on
    elseif normalization(i) < 0.4
        k=25
        plot([lon(i),lon(i+1)],[lat(i),lat(i+1)],'color',a(k,:),'LineWidth',2 )
        hold on
    elseif normalization(i) < 0.5
        k=30
        plot([lon(i),lon(i+1)],[lat(i),lat(i+1)],'color',a(k,:),'LineWidth',2 )
        hold on
    elseif normalization(i) < 0.6
        k=38
        plot([lon(i),lon(i+1)],[lat(i),lat(i+1)],'color',a(k,:),'LineWidth',2 )
        hold on
    elseif normalization(i) < 1 & normalization(i)>=0.9
        k=63
        plot([lon(i),lon(i+1)],[lat(i),lat(i+1)],'color',a(k,:),'LineWidth',2 )
        hold on
    end
end
plot_google_map('MapScale', 1)
caxis([15 16])
hold off





