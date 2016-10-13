function [featureVector] = buildFeatureVector(data,mode,timeLine)
%BUILDFEATUREVECTOR Summary of this function goes here
%   Detailed explanation goes here


switch mode
    
    case '3Achsen'
        %% Relative Beschleunigung
        figure
        hold on
        plot(data(:,1),'Color','blue');
        plot(data(:,2),'Color','red');
        plot(data(:,3),'Color','green');
        xlabel('Zeit');ylabel('Beschleunigung');
        title('Relative Beschleunigung in drei Achsen')
        legend('x-Acc','y-Acc','z-Acc','Location','NorthEastOutside')
        hold off
        
        featureVector=[data(:,1),data(:,2),data(:,3)];
        
    case 'effektiv'
        %% Effektivwert
        effAcc=sqrt(data(:,1).^2+data(:,2).^2+data(:,3).^2);
        figure
        hold on
        plot(effAcc,'Color','blue');
        xlabel('Zeit');ylabel('Beschleunigung');
        title('Effektive Beschleunigung in alle drei Achsen')
        hold off
        
        featureVector=effAcc';
        
    case 'effektiv+normiert'
        %% Effektivwert mit normierter Beschleunigung
        maxValue=10*2;

        normXData=data(:,1)-min(data(:,1));
        normXData=(normXData.*maxValue/max(normXData(:,1)))-maxValue/2;
        normYData=data(:,2)-min(data(:,2));
        normYData=(normYData.*maxValue/max(normYData(:,1)))-maxValue/2;
        normZData=data(:,3)-min(data(:,3));
        normZData=(normZData.*maxValue/max(normZData(:,1)))-maxValue/2;
        
        effAcc=sqrt(normXData.^2+normYData.^2+normZData.^2);
        figure
        hold on
        plot(effAcc,'Color','blue');
        xlabel('Zeit');ylabel('Beschleunigung');
        title('Effektive Beschleunigung in alle drei Achsen')
        hold off
        
        featureVector=effAcc';
    case '3Achsen+normiert'
        %% Achsenbeschleunigung normiert
        maxValue=10*2;

        normXData=data(:,1)-min(data(:,1));
        normXData=(normXData.*maxValue/max(normXData(:,1)))-maxValue/2;
        normYData=data(:,2)-min(data(:,2));
        normYData=(normYData.*maxValue/max(normYData(:,1)))-maxValue/2;
        normZData=data(:,3)-min(data(:,3));
        normZData=(normZData.*maxValue/max(normZData(:,1)))-maxValue/2;
        
        figure
        hold on
        plot(normXData,'Color','blue');
        plot(normYData,'Color','red');
        plot(normZData,'Color','green');
        xlabel('Zeit');ylabel('Beschleunigung');
        title('Beschleunigung aller Achsen - Normierte Beschleunigung')
        legend('x-Acc','y-Acc','z-Acc','Location','NorthEastOutside')
        hold off
        
        featureVector=[normXData,normYData,normZData];
        
    case '3Achsen+normiert+skaliertMesspunk'
        %% Achsen normieren und danach skalieren nach Messpunkten
        maxValue=10*2;

        normXData=data(:,1)-min(data(:,1));
        normXData=(normXData.*maxValue/max(normXData(:,1)))-maxValue/2;
        normYData=data(:,2)-min(data(:,2));
        normYData=(normYData.*maxValue/max(normYData(:,1)))-maxValue/2;
        normZData=data(:,3)-min(data(:,3));
        normZData=(normZData.*maxValue/max(normZData(:,1)))-maxValue/2;
        
        data=[normXData,normYData,normZData];
        
        n=100;
        numberOfPoints=size(data,1);
        windowSize=numberOfPoints/n;

        pointedAccX=[];
        pointedAccY=[];
        pointedAccZ=[];

        windowEnd=1;
        for i=1:n
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

                accValuesX=data(windowStart,1);
                accValuesY=data(windowStart,2);
                accValuesZ=data(windowStart,3);
            else
                %Interpolation zwischen zwei Punkten (LOW)
                accLow=data(windowStartLow,1);
                accHigh=data(windowStartHigh,1);
                diff=accHigh-accLow;

                %Prozentanteil der Steigung
                p=windowStart-windowStartLow;
                windowStartValue=accLow+diff*p;

                accValuesX=[windowStartValue; data(windowStartHigh,1)];

                %Interpolation zwischen zwei Punkten (LOW)
                accLow=data(windowStartLow,2);
                accHigh=data(windowStartHigh,2);
                diff=accHigh-accLow;

                %Prozentanteil der Steigung
                p=windowStart-windowStartLow;
                windowStartValue=accLow+diff*p;

                accValuesY=[windowStartValue; data(windowStartHigh,2)];

                %Interpolation zwischen zwei Punkten (LOW)
                accLow=data(windowStartLow,3);
                accHigh=data(windowStartHigh,3);
                diff=accHigh-accLow;

                %Prozentanteil der Steigung
                p=windowStart-windowStartLow;
                windowStartValue=accLow+diff*p;

                accValuesZ=[windowStartValue; data(windowStartHigh,3)];
            end

            %Restliche Werte hinzufügen
            for j=windowStartHigh+1:floor(windowEnd)-1
                accValuesX=[accValuesX; data(j,1)];
                accValuesY=[accValuesY; data(j,2)];
                accValuesZ=[accValuesZ; data(j,3)];
            end

            %WINDOWEND
            windowEndLow=floor(windowEnd);
            windowEndHigh=ceil(windowEnd);

            if(windowEndLow==windowEndHigh)
                windowEnd=windowEndLow;

                accValuesX=[accValuesX; data(windowEnd,1)];
                accValuesY=[accValuesY; data(windowEnd,2)];
                accValuesZ=[accValuesZ; data(windowEnd,3)];
            else
                %Interpolation zwischen zwei Punkten (LOW)
                accLow=data(windowEndLow,1);
                accHigh=data(windowEndHigh,1);
                diff=accHigh-accLow;

                %Prozentanteil der Steigung
                p=windowEnd-windowEndLow;
                windowEndValue=accLow+diff*p;

                accValuesX=[accValuesX; data(windowEndLow,1); windowEndValue];

                %Interpolation zwischen zwei Punkten (LOW)
                accLow=data(windowEndLow,2);
                accHigh=data(windowEndHigh,2);
                diff=accHigh-accLow;

                %Prozentanteil der Steigung
                p=windowEnd-windowEndLow;
                windowEndValue=accLow+diff*p;

                accValuesY=[accValuesY; data(windowEndLow,2); windowEndValue];

                %Interpolation zwischen zwei Punkten (LOW)
                accLow=data(windowEndLow,3);
                accHigh=data(windowEndHigh,3);
                diff=accHigh-accLow;

                %Prozentanteil der Steigung
                p=windowEnd-windowEndLow;
                windowEndValue=accLow+diff*p;

                accValuesZ=[accValuesZ; data(windowEndLow,3); windowEndValue];
            end

            newAccX=mean(accValuesX);
            newAccY=mean(accValuesY);
            newAccZ=mean(accValuesZ);

            pointedAccX=[pointedAccX; newAccX];
            pointedAccY=[pointedAccY; newAccY];
            pointedAccZ=[pointedAccZ; newAccZ];     
        end

        figure
        hold on
        plot(pointedAccX,'Color','blue');
        plot(pointedAccY,'Color','green');
        plot(pointedAccZ,'Color','red');
        xlabel('Zeit');ylabel('Beschleunigung');
        title('Beschleunigung der x-Achsen - Zeitskalierung nach Messpunkten')
        hold off
        
        featureVector=[pointedAccX,pointedAccY,pointedAccZ];
        
    case '3Achsen+normiert+skaliertZeit'
        %% Achsen normieren und skalieren nach Zeit
        maxValue=10*2;

        normXData=data(:,1)-min(data(:,1));
        normXData=(normXData.*maxValue/max(normXData(:,1)))-maxValue/2;
        normYData=data(:,2)-min(data(:,2));
        normYData=(normYData.*maxValue/max(normYData(:,1)))-maxValue/2;
        normZData=data(:,3)-min(data(:,3));
        normZData=(normZData.*maxValue/max(normZData(:,1)))-maxValue/2;
        
        data=[normXData,normYData,normZData];
        %Anzahl der Zeitfenster
        n=100;

        duration=timeLine(end);
        windowSize=duration/n;

        timedAccX=[];
        timedAccY=[];
        timedAccZ=[];

        endTime=timeLine(1,1);
        for i=1:n

            startTime=endTime;
            endTime=startTime+windowSize;

            if(endTime>duration)
                endTime=timeLine(end);
            end

            [startValue startIndex]=getAccValueByTimeLine(timeLine,data,startTime,'start');
            [endValue endIndex]=getAccValueByTimeLine(timeLine,data,endTime,'end');
            newAcc=startValue;
            for j=startIndex:endIndex
                newAcc=[newAcc; data(j,1:3)];
            end
            newAcc=[newAcc; endValue];

            newAccX=mean(newAcc(:,1));
            newAccY=mean(newAcc(:,2));
            newAccZ=mean(newAcc(:,3));

            timedAccX=[timedAccX; newAccX];
            timedAccY=[timedAccY; newAccY];
            timedAccZ=[timedAccZ; newAccZ];
        end

        figure
        hold on
        plot(timedAccX,'Color','blue');
        plot(timedAccY,'Color','green');
        plot(timedAccZ,'Color','red');
        xlabel('Zeit');ylabel('Beschleunigung');
        title('Beschleunigung der x-Achsen - Zeitskalierung nach zeit in ms')
        hold off
        
        featureVector=[timedAccX,timedAccY,timedAccZ];
        
    case '3Achsen+normiert+skaliertZeit(normal)'
        %% Achsen normieren und skalieren nach Zeit
        maxValue=10*2;

        normXData=data(:,1)-min(data(:,1));
        normXData=(normXData.*maxValue/max(normXData(:,1)))-maxValue/2;
        normYData=data(:,2)-min(data(:,2));
        normYData=(normYData.*maxValue/max(normYData(:,1)))-maxValue/2;
        normZData=data(:,3)-min(data(:,3));
        normZData=(normZData.*maxValue/max(normZData(:,1)))-maxValue/2;
        
        data=[normXData,normYData,normZData];
        %Anzahl der Zeitfenster
        n=100;

        duration=timeLine(end);
        windowSize=duration/n;

        timedAccX=[];
        timedAccY=[];
        timedAccZ=[];

        endTime=timeLine(1,1);
        for i=1:n

            startTime=endTime;
            endTime=startTime+windowSize;

            if(endTime>duration)
                endTime=timeLine(end);
            end

            [startValue startIndex]=getAccValueByTimeLine(timeLine,data,startTime,'start');
            [endValue endIndex]=getAccValueByTimeLine(timeLine,data,endTime,'end');
            newAcc=startValue;
            for j=startIndex:endIndex
                newAcc=[newAcc; data(j,1:3)];
            end
            newAcc=[newAcc; endValue];

            newAccX=mean(newAcc(:,1));
            newAccY=mean(newAcc(:,2));
            newAccZ=mean(newAcc(:,3));

            timedAccX=[timedAccX; newAccX];
            timedAccY=[timedAccY; newAccY];
            timedAccZ=[timedAccZ; newAccZ];
        end

        figure
        hold on
        plot(timedAccX,'Color','blue');
        plot(timedAccY,'Color','green');
        plot(timedAccZ,'Color','red');
        xlabel('Zeit');ylabel('Beschleunigung');
        title('Beschleunigung der x-Achsen - Zeitskalierung nach zeit in ms')
        hold off
        
        featureVector=[timedAccX,timedAccY,timedAccZ];
    case '3Achsen+normiert+skaliertZeit(überlappend)'
        %% Achsen normieren und skalieren nach Zeit
        maxValue=10*2;

        normXData=data(:,1)-min(data(:,1));
        normXData=(normXData.*maxValue/max(normXData(:,1)))-maxValue/2;
        normYData=data(:,2)-min(data(:,2));
        normYData=(normYData.*maxValue/max(normYData(:,1)))-maxValue/2;
        normZData=data(:,3)-min(data(:,3));
        normZData=(normZData.*maxValue/max(normZData(:,1)))-maxValue/2;
        
        data=[normXData,normYData,normZData];
        %Anzahl der Zeitfenster
        n=100;

        duration=timeLine(end);
        windowSize=duration/n;
        
        timedAccX=[];
        timedAccY=[];
        timedAccZ=[];

        endTime=timeLine(1,1)+windowSize/2;
        for i=1:n*2-1

            startTime=endTime-windowSize/2;
            endTime=startTime+windowSize;

            if(endTime>duration)
                endTime=timeLine(end);
            end

            [startValue startIndex]=getAccValueByTimeLine(timeLine,data,startTime,'start');
            [endValue endIndex]=getAccValueByTimeLine(timeLine,data,endTime,'end');
            newAcc=startValue;
            for j=startIndex:endIndex
                newAcc=[newAcc; data(j,1:3)];
            end
            newAcc=[newAcc; endValue];

            newAccX=mean(newAcc(:,1));
            newAccY=mean(newAcc(:,2));
            newAccZ=mean(newAcc(:,3));

            timedAccX=[timedAccX; newAccX];
            timedAccY=[timedAccY; newAccY];
            timedAccZ=[timedAccZ; newAccZ];
        end

        figure
        hold on
        plot(timedAccX,'Color','blue');
        plot(timedAccY,'Color','green');
        plot(timedAccZ,'Color','red');
        xlabel('Zeit');ylabel('Beschleunigung');
        title('Beschleunigung der x-Achsen - Überlappende Zeitskalierung nach zeit in ms')
        hold off
        
        featureVector=[timedAccX,timedAccY,timedAccZ];
        
    case '3Achsen+skaliertMesspunk'
        %% Achsen skalieren nach Messpunkten
        n=100;
        numberOfPoints=size(data,1);
        windowSize=numberOfPoints/n;

        pointedAccX=[];
        pointedAccY=[];
        pointedAccZ=[];

        windowEnd=1;
        for i=1:n
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

                accValuesX=data(windowStart,1);
                accValuesY=data(windowStart,2);
                accValuesZ=data(windowStart,3);
            else
                %Interpolation zwischen zwei Punkten (LOW)
                accLow=data(windowStartLow,1);
                accHigh=data(windowStartHigh,1);
                diff=accHigh-accLow;

                %Prozentanteil der Steigung
                p=windowStart-windowStartLow;
                windowStartValue=accLow+diff*p;

                accValuesX=[windowStartValue; data(windowStartHigh,1)];

                %Interpolation zwischen zwei Punkten (LOW)
                accLow=data(windowStartLow,2);
                accHigh=data(windowStartHigh,2);
                diff=accHigh-accLow;

                %Prozentanteil der Steigung
                p=windowStart-windowStartLow;
                windowStartValue=accLow+diff*p;

                accValuesY=[windowStartValue; data(windowStartHigh,2)];

                %Interpolation zwischen zwei Punkten (LOW)
                accLow=data(windowStartLow,3);
                accHigh=data(windowStartHigh,3);
                diff=accHigh-accLow;

                %Prozentanteil der Steigung
                p=windowStart-windowStartLow;
                windowStartValue=accLow+diff*p;

                accValuesZ=[windowStartValue; data(windowStartHigh,3)];
            end

            %Restliche Werte hinzufügen
            for j=windowStartHigh+1:floor(windowEnd)-1
                accValuesX=[accValuesX; data(j,1)];
                accValuesY=[accValuesY; data(j,2)];
                accValuesZ=[accValuesZ; data(j,3)];
            end

            %WINDOWEND
            windowEndLow=floor(windowEnd);
            windowEndHigh=ceil(windowEnd);

            if(windowEndLow==windowEndHigh)
                windowEnd=windowEndLow;

                accValuesX=[accValuesX; data(windowEnd,1)];
                accValuesY=[accValuesY; data(windowEnd,2)];
                accValuesZ=[accValuesZ; data(windowEnd,3)];
            else
                %Interpolation zwischen zwei Punkten (LOW)
                accLow=data(windowEndLow,1);
                accHigh=data(windowEndHigh,1);
                diff=accHigh-accLow;

                %Prozentanteil der Steigung
                p=windowEnd-windowEndLow;
                windowEndValue=accLow+diff*p;

                accValuesX=[accValuesX; data(windowEndLow,1); windowEndValue];

                %Interpolation zwischen zwei Punkten (LOW)
                accLow=data(windowEndLow,2);
                accHigh=data(windowEndHigh,2);
                diff=accHigh-accLow;

                %Prozentanteil der Steigung
                p=windowEnd-windowEndLow;
                windowEndValue=accLow+diff*p;

                accValuesY=[accValuesY; data(windowEndLow,2); windowEndValue];

                %Interpolation zwischen zwei Punkten (LOW)
                accLow=data(windowEndLow,3);
                accHigh=data(windowEndHigh,3);
                diff=accHigh-accLow;

                %Prozentanteil der Steigung
                p=windowEnd-windowEndLow;
                windowEndValue=accLow+diff*p;

                accValuesZ=[accValuesZ; data(windowEndLow,3); windowEndValue];
            end

            newAccX=mean(accValuesX);
            newAccY=mean(accValuesY);
            newAccZ=mean(accValuesZ);

            pointedAccX=[pointedAccX; newAccX];
            pointedAccY=[pointedAccY; newAccY];
            pointedAccZ=[pointedAccZ; newAccZ];     
        end

        figure
        hold on
        plot(pointedAccX,'Color','blue');
        plot(pointedAccY,'Color','green');
        plot(pointedAccZ,'Color','red');
        xlabel('Zeit');ylabel('Beschleunigung');
        title('Beschleunigung der x-Achsen - Zeitskalierung nach Messpunkten')
        hold off
        
        featureVector=[pointedAccX,pointedAccY,pointedAccZ];
        
    case '3Achsen+skaliertZeit'
        %% Achsen werden skaliert nach Zeit
        %Anzahl der Zeitfenster
        n=100;

        duration=timeLine(end);
        windowSize=duration/n;

        timedAccX=[];
        timedAccY=[];
        timedAccZ=[];

        endTime=timeLine(1,1);
        for i=1:n

            startTime=endTime;
            endTime=startTime+windowSize;

            if(endTime>duration)
                endTime=timeLine(end);
            end
                        
            [startValue startIndex]=getAccValueByTimeLine(timeLine,data,startTime,'start');
            [endValue endIndex]=getAccValueByTimeLine(timeLine,data,endTime,'end');
            newAcc=startValue;
            for j=startIndex:endIndex
                newAcc=[newAcc; data(j,1:3)];
            end
            newAcc=[newAcc; endValue];

            newAccX=mean(newAcc(:,1));
            newAccY=mean(newAcc(:,2));
            newAccZ=mean(newAcc(:,3));

            timedAccX=[timedAccX; newAccX];
            timedAccY=[timedAccY; newAccY];
            timedAccZ=[timedAccZ; newAccZ];
        end

        figure
        hold on
        plot(timedAccX,'Color','blue');
        plot(timedAccY,'Color','green');
        plot(timedAccZ,'Color','red');
        xlabel('Zeit');ylabel('Beschleunigung');
        title('Beschleunigung der x-Achsen - Zeitskalierung nach zeit in ms')
        hold off
        
        featureVector=[timedAccX,timedAccY,timedAccZ];
        
    case '3Achsen+skaliertZeit(normal)'
        %% Achsen werden skaliert nach Zeit
        %Anzahl der Zeitfenster
        n=100;

        duration=timeLine(end);
        windowSize=duration/n;

        timedAccX=[];
        timedAccY=[];
        timedAccZ=[];

        endTime=timeLine(1,1);
        for i=1:n

            startTime=endTime;
            endTime=startTime+windowSize;

            if(endTime>duration)
                endTime=timeLine(end);
            end
            
            [startValue startIndex]=getAccValueByTimeLine(timeLine,data,startTime,'start');
            [endValue endIndex]=getAccValueByTimeLine(timeLine,data,endTime,'end');
            newAcc=startValue;
            for j=startIndex:endIndex
                newAcc=[newAcc; data(j,1:3)];
            end
            newAcc=[newAcc; endValue];

            newAccX=mean(newAcc(:,1));
            newAccY=mean(newAcc(:,2));
            newAccZ=mean(newAcc(:,3));

            timedAccX=[timedAccX; newAccX];
            timedAccY=[timedAccY; newAccY];
            timedAccZ=[timedAccZ; newAccZ];
        end

        figure
        hold on
        plot(timedAccX,'Color','blue');
        plot(timedAccY,'Color','green');
        plot(timedAccZ,'Color','red');
        xlabel('Zeit');ylabel('Beschleunigung');
        title('Beschleunigung der x-Achsen - Zeitskalierung nach zeit in ms')
        hold off
        
        featureVector=[timedAccX,timedAccY,timedAccZ];
        
    case '3Achsen+skaliertZeit(überlappend)'
        %% Achsen werden skaliert nach Zeit
        %Anzahl der Zeitfenster
        n=100;

        duration=timeLine(end);
        windowSize=duration/n;
        
        timedAccX=[];
        timedAccY=[];
        timedAccZ=[];

        endTime=timeLine(1,1)+windowSize/2;
        for i=1:n*2-1

            startTime=endTime-windowSize/2;
            endTime=startTime+windowSize;

            if(endTime>duration)
                endTime=timeLine(end);
            end

            [startValue startIndex]=getAccValueByTimeLine(timeLine,data,startTime,'start');
            [endValue endIndex]=getAccValueByTimeLine(timeLine,data,endTime,'end');
            newAcc=startValue;
            for j=startIndex:endIndex
                newAcc=[newAcc; data(j,1:3)];
            end
            newAcc=[newAcc; endValue];

            newAccX=mean(newAcc(:,1));
            newAccY=mean(newAcc(:,2));
            newAccZ=mean(newAcc(:,3));

            timedAccX=[timedAccX; newAccX];
            timedAccY=[timedAccY; newAccY];
            timedAccZ=[timedAccZ; newAccZ];
        end

        figure
        hold on
        plot(timedAccX,'Color','blue');
        plot(timedAccY,'Color','green');
        plot(timedAccZ,'Color','red');
        xlabel('Zeit');ylabel('Beschleunigung');
        title('Beschleunigung der x-Achsen - Überlappende Zeitskalierung nach zeit in ms')
        hold off
        
        featureVector=[timedAccX,timedAccY,timedAccZ];
        
    otherwise
        %% Unbekannter Mode
        disp(['Fehler: Unbekannter FeatureMode! Mode:' mode]);
        featureVector=0;
end

end

