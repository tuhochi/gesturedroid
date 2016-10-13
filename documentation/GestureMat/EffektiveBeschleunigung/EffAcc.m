%Effektive Beschleunigung

%Testfile
file='training/4hammer/2010.12.08.23.36.35.txt';

%Laden der relativen Beschleunigungswerte
data=load(file);
data=[data(:,1)./1000000000 data(:,2) data(:,3) data(:,4)];

%% Berechnung der zurückgelegten Distanz

%% Ploten der 3 relativen Achsenbeschleunigungen
%Unveränderte Daten
figure
hold on
plot(data(:,2),'Color','blue');
plot(data(:,3),'Color','red');
plot(data(:,4),'Color','green');
xlabel('Zeit');ylabel('Beschleunigung');
title('Relative Beschleunigung in drei Achsen')
legend('x-Acc','y-Acc','z-Acc','Location','NorthEastOutside')
hold off

%mit Translation in positiven Bereich
dataPosX=data(:,2)+abs(min(data(:,2)));
dataPosY=data(:,3)+abs(min(data(:,3)));
dataPosZ=data(:,4)+abs(min(data(:,4)));
figure
hold on
plot(dataPosX,'Color','blue');
plot(dataPosY,'Color','red');
plot(dataPosZ,'Color','green');
xlabel('Zeit');ylabel('Beschleunigung');
title('Relative Beschleunigung in drei Achsen')
legend('x-Acc','y-Acc','z-Acc','Location','NorthEastOutside')
hold off

%% Berechnen der effektiven Beschleunigung
effAcc=sqrt(data(:,2).^2+data(:,3).^2+data(:,4).^2);
figure
hold on
plot(effAcc,'Color','blue');
xlabel('Zeit');ylabel('Beschleunigung');
title('Effektive Beschleunigung in alle drei Achsen')
hold off

%% Berechnung der effektiven Beschleunigung mit Normierung
%Berechnung der Beschleunigungsnormierung
maxValue=10*2;

normXData=data(:,2)-min(data(:,2));
normXData=(normXData.*maxValue/max(normXData(:,1)))-maxValue/2;
normYData=data(:,3)-min(data(:,3));
normYData=(normYData.*maxValue/max(normYData(:,1)))-maxValue/2;
normZData=data(:,4)-min(data(:,4));
normZData=(normZData.*maxValue/max(normZData(:,1)))-maxValue/2;

%*******************************************
% Nur normierte Beschleunigungswerte
%*******************************************
figure
hold on
plot(normXData,'Color','blue');
plot(normYData,'Color','red');
plot(normZData,'Color','green');
xlabel('Zeit');ylabel('Beschleunigung');
title('Beschleunigung aller Achsen - Normierte Beschleunigung')
legend('x-Acc','y-Acc','z-Acc','Location','NorthEastOutside')
hold off
%*******************************************

%Berechnung der Zeit-Skalierung anhand Messpunkte
%Anzahl der Zeitfenster
n=100;
numberOfPoints=size(data,1);
windowSize=numberOfPoints/n;

pointedAccX=[];
pointedAccY=[];
pointedAccZ=[];

windowEnd=1;
for i=1:n %%%%%% FEHLER!!!! NORMIERTE FEHLEN
    windowStart=windowEnd;
    windowEnd=windowStart+windowSize;
    
    if(windowEnd>numberOfPoints)
        windowEnd=numberOfPoints;
    end
    
    %WINDOWSTART
    windowStartLow=floor(windowStart);
    windowStartHigh=ceil(windowStart);
    
    if(windowStartLow==windowStartHigh)
        windowStart=windowStartLow;
        
        accValuesX=data(windowStart,2);
        accValuesY=data(windowStart,3);
        accValuesZ=data(windowStart,4);
    else
        %Interpolation zwischen zwei Punkten (LOW)
        accLow=data(windowStartLow,2);
        accHigh=data(windowStartHigh,2);
        diff=accHigh-accLow;
        
        %Prozentanteil der Steigung
        p=windowStart-windowStartLow;
        windowStartValue=accLow+diff*p;
        
        accValuesX=[windowStartValue; data(windowStartHigh,2)];
        
        %Interpolation zwischen zwei Punkten (LOW)
        accLow=data(windowStartLow,3);
        accHigh=data(windowStartHigh,3);
        diff=accHigh-accLow;
        
        %Prozentanteil der Steigung
        p=windowStart-windowStartLow;
        windowStartValue=accLow+diff*p;
        
        accValuesY=[windowStartValue; data(windowStartHigh,3)];
        
        %Interpolation zwischen zwei Punkten (LOW)
        accLow=data(windowStartLow,4);
        accHigh=data(windowStartHigh,4);
        diff=accHigh-accLow;
        
        %Prozentanteil der Steigung
        p=windowStart-windowStartLow;
        windowStartValue=accLow+diff*p;
        
        accValuesZ=[windowStartValue; data(windowStartHigh,4)];
    end
    
    %Restliche Werte hinzufügen
    for j=windowStartHigh+1:floor(windowEnd)-1
        accValuesX=[accValuesX; data(j,2)];
        accValuesY=[accValuesY; data(j,3)];
        accValuesZ=[accValuesZ; data(j,4)];
    end
    
    %WINDOWEND
    windowEndLow=floor(windowEnd);
    windowEndHigh=ceil(windowEnd);
    
    if(windowEndLow==windowEndHigh)
        windowEnd=windowEndLow;
        
        accValuesX=[accValuesX; data(windowEnd,2)];
        accValuesY=[accValuesY; data(windowEnd,3)];
        accValuesZ=[accValuesZ; data(windowEnd,4)];
    else
        %Interpolation zwischen zwei Punkten (LOW)
        accLow=data(windowEndLow,2);
        accHigh=data(windowEndHigh,2);
        diff=accHigh-accLow;
        
        %Prozentanteil der Steigung
        p=windowEnd-windowEndLow;
        windowEndValue=accLow+diff*p;
        
        accValuesX=[accValuesX; data(windowEndLow,2); windowEndValue];
        
        %Interpolation zwischen zwei Punkten (LOW)
        accLow=data(windowEndLow,3);
        accHigh=data(windowEndHigh,3);
        diff=accHigh-accLow;
        
        %Prozentanteil der Steigung
        p=windowEnd-windowEndLow;
        windowEndValue=accLow+diff*p;
        
        accValuesY=[accValuesY; data(windowEndLow,3); windowEndValue];
        
        %Interpolation zwischen zwei Punkten (LOW)
        accLow=data(windowEndLow,4);
        accHigh=data(windowEndHigh,4);
        diff=accHigh-accLow;
        
        %Prozentanteil der Steigung
        p=windowEnd-windowEndLow;
        windowEndValue=accLow+diff*p;
        
        accValuesZ=[accValuesZ; data(windowEndLow,4); windowEndValue];
    end
    
    newAccX=mean(accValuesX);
    newAccY=mean(accValuesY);
    newAccZ=mean(accValuesZ);
        
    %newAccX=sum(data(windowStart:windowEnd,2))/size(data(windowStart:windowEnd,2),1);
    %newAccX=sum(normXData(windowStart:windowEnd,1))/size(normXData(windowStart:windowEnd,2),1);
    %newAccY=sum(data(windowStart:windowEnd,3))/size(data(windowStart:windowEnd,2),1);
    %newAccY=sum(normYData(windowStart:windowEnd,1))/size(normYData(windowStart:windowEnd,2),1);
    %newAccZ=sum(data(windowStart:windowEnd,4))/size(data(windowStart:windowEnd,2),1);
    %newAccZ=sum(normZData(windowStart:windowEnd,1))/size(normZData(windowStart:windowEnd,2),1);
    
    pointedAccX=[pointedAccX; newAccX];
    pointedAccY=[pointedAccY; newAccY];
    pointedAccZ=[pointedAccZ; newAccZ];
end

%*******************************************
% Nur zeit-skalierte Beschleunigungswerte
%*******************************************
figure
hold on
plot(pointedAccX,'Color','blue');
plot(pointedAccY,'Color','green');
plot(pointedAccZ,'Color','red');
xlabel('Zeit');ylabel('Beschleunigung');
title('Beschleunigung der x-Achsen - Zeitskalierung nach Messpunkten')
hold off
%*******************************************


%Berechnung der Zeit-Skalierung anhand der Zeit
%Anzahl der Zeitfenster
n=100;
mode='normal';
%mode='überlappend';

duration=sum(data(:,1));
windowSize=duration/n;

%Zeitlinie hinzufügen
timeLine(1)=data(1,1);
for i=2:size(data,1)
    timeLine(i)=timeLine(i-1)+data(i,1);
end
timeLine=timeLine';

if strcmp(mode,'normal')
    
    timedAccX=[];
    timedAccY=[];
    timedAccZ=[];
    
    endTime=timeLine(1,1);
    for i=1:n
        
        startTime=endTime;
        endTime=startTime+windowSize;
        
        if(endTime>duration)
            endTime=size(data,1);
        end
        
        [startValue startIndex]=getAccValueByTimeLine(timeLine,data(:,2:4),startTime,'start');
        [endValue endIndex]=getAccValueByTimeLine(timeLine,data(:,2:4),endTime,'end');
        newAcc=startValue;
        for j=startIndex:endIndex
            newAcc=[newAcc; data(j,2:4)];
        end
        newAcc=[newAcc; endValue];
        
        newAccX=mean(newAcc(:,1));
        newAccY=mean(newAcc(:,2));
        newAccZ=mean(newAcc(:,3));
        
%         startAccX=data(windowStart,2);
%         %startAccX=normXData(windowStart);
%         endAccX=data(windowEnd,2);
%         %endAccX=normXData(windowEnd);
%         
%         newAccX=sum(data(windowStart:windowEnd,2))/size(data(windowStart:windowEnd,2),1);
%         %newAccX=sum(normXData(windowStart:windowEnd,2))/size(normXData(windowStart:windowEnd,2),1);
%         newAccY=sum(data(windowStart:windowEnd,3))/size(data(windowStart:windowEnd,2),1);
%         %newAccY=sum(normYData(windowStart:windowEnd,1))/size(normYData(windowStart:windowEnd,2),1);
%         newAccZ=sum(data(windowStart:windowEnd,4))/size(data(windowStart:windowEnd,2),1);
%         %newAccZ=sum(normZData(windowStart:windowEnd,1))/size(normZData(windowStart:windowEnd,2),1);
        
        timedAccX=[timedAccX; newAccX];
        timedAccY=[timedAccY; newAccY];
        timedAccZ=[timedAccZ; newAccZ];
    end
    %*******************************************
    % Nur zeit-skalierte Beschleunigungswerte
    %*******************************************
    figure
    hold on
    plot(timedAccX,'Color','blue');
    plot(timedAccY,'Color','green');
    plot(timedAccZ,'Color','red');
    xlabel('Zeit');ylabel('Beschleunigung');
    title('Beschleunigung der x-Achsen - Zeitskalierung nach zeit in ms')
    hold off
    %*******************************************
else
    windowStartSub=windowSize/2;
    timedAccX=[];
    timedAccY=[];
    timedAccZ=[];
    
    endTime=timeLine(1,1)+windowSize/2;
    for i=1:n*2-1
        
        startTime=endTime-windowSize/2;
        endTime=startTime+windowSize;
        
        if(endTime>duration)
            endTime=size(data,1);
        end
        
        [startValue startIndex]=getAccValueByTimeLine(timeLine,data(:,2:4),startTime,'start');
        [endValue endIndex]=getAccValueByTimeLine(timeLine,data(:,2:4),endTime,'end');
        newAcc=startValue;
        for j=startIndex:endIndex
            newAcc=[newAcc; data(j,2:4)];
        end
        newAcc=[newAcc; endValue];

        newAccX=mean(newAcc(:,1));
        newAccY=mean(newAcc(:,2));
        newAccZ=mean(newAcc(:,3));

        timedAccX=[timedAccX; newAccX];
        timedAccY=[timedAccY; newAccY];
        timedAccZ=[timedAccZ; newAccZ];

        
        
        
        
        
        
        
%         %Überlappendes Fenster
%         if(i>windowSize)
%             %Zwischenfenster
%             windowEndSub=i+windowSize/2;
%             
%             if(windowEndSub>duration)
%                 windowEndSub=size(data,1);
%             end
%             startAccX=data(windowStartSub,2);
%             %startAccX=normXData(windowStartSub);
%             endAccX=data(windowEndSub,2);
%             %endAccX=normXData(windowEndSub);
%             
%             newAccX=sum(data(windowStartSub:windowEndSub,2))/size(data(windowStartSub:windowEndSub,2),1);
%             %newAccX=sum(normXData(windowStartSub:windowEndSub,2))/size(normXData(windowStartSub:windowEndSub,2),1);
%             newAccY=sum(data(windowStart:windowEnd,3))/size(data(windowStart:windowEnd,2),1);
%             %newAccY=sum(normYData(windowStart:windowEnd,1))/size(normYData(windowStart:windowEnd,2),1);
%             newAccZ=sum(data(windowStart:windowEnd,4))/size(data(windowStart:windowEnd,2),1);
%             %newAccZ=sum(normZData(windowStart:windowEnd,1))/size(normZData(windowStart:windowEnd,2),1);
% 
%             timedAccX=[timedAccX; newAccX];
%             timedAccY=[timedAccY; newAccY];
%             timedAccZ=[timedAccZ; newAccZ];
%             windowStartSub=windowEndNext;
%         end
%         
%         windowStart=i;
%         windowEnd=i+windowSize;
%        
%         if(windowEnd>duration)
%             windowEnd=size(data,1);
%         end
% 
%         startAccX=data(windowStart,2);
%         %startAccX=normXData(windowStart);
%         endAccX=data(windowEnd,2);
%         %endAccX=normXData(windowEnd);
%         
%         newAccX=sum(data(windowStart:windowEnd,2))/size(data(windowStart:windowEnd,2),1);
%         %newAccX=sum(normXData(windowStart:windowEnd,2))/size(normXData(windowStart:windowEnd,2),1);
%         newAccY=sum(data(windowStart:windowEnd,3))/size(data(windowStart:windowEnd,2),1);
%         %newAccY=sum(normYData(windowStart:windowEnd,1))/size(normYData(windowStart:windowEnd,2),1);
%         newAccZ=sum(data(windowStart:windowEnd,4))/size(data(windowStart:windowEnd,2),1);
%         %newAccZ=sum(normZData(windowStart:windowEnd,1))/size(normZData(windowStart:windowEnd,2),1);
% 
%         timedAccX=[timedAccX; newAccX];
%         timedAccY=[timedAccY; newAccY]; 
%         timedAccZ=[timedAccZ; newAccZ]; 
     end
    %*******************************************
    % Nur zeit-skalierte Beschleunigungswerte
    %*******************************************
    figure
    hold on
    plot(timedAccX,'Color','blue');
    plot(timedAccY,'Color','green');
    plot(timedAccZ,'Color','red');
    xlabel('Zeit');ylabel('Beschleunigung');
    title('Beschleunigung der x-Achsen - Überlappende Zeitskalierung nach zeit in ms')
    hold off
    %*******************************************
end

