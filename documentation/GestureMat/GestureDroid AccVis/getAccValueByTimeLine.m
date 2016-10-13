function [value,i] = getAccValueByTimeLine(timeline,data,time,type)
%GETINDEXFROMTIMELINE Summary of this function goes here
%   Detailed explanation goes here

    %Error-Handling
    value=0;
    
    if size(data,2)==3
        for i=1:size(timeline,1)

            if timeline(i)==time
                value=[data(i,1),data(i,2),data(i,3)];

                if strcmp(type,'end')
                    i=i-1;
                else
                    i=i+1;
                end
                return
            end

            if timeline(i)<time && time<timeline(i+1)
                %Zeitpunkt befindet sich zwischen i & i+1
                accBefore=[data(i,1),data(i,2),data(i,3)];
                accAfter=[data(i+1,1),data(i+1,2),data(i+1,3)];
                diffAcc=accAfter-accBefore;

                diffTime=timeline(i+1)-timeline(i);
                timeGap=time-timeline(i);

                p=(100/diffTime*timeGap)/100;
                value=accBefore+diffAcc*p; 
                return           
            end

            %Error-Handling
            value=0;
        end
    else
        for i=1:size(timeline,1)

            if timeline(i)==time
                value=data(i,1);

                if strcmp(type,'end')
                    i=i-1;
                else
                    i=i+1;
                end
                return
            end

            if timeline(i)<time && time<timeline(i+1)
                %Zeitpunkt befindet sich zwischen i & i+1
                accBefore=data(i,1);
                accAfter=data(i+1,1);
                diffAcc=accAfter-accBefore;

                diffTime=timeline(i+1)-timeline(i);
                timeGap=time-timeline(i);

                p=(100/diffTime*timeGap)/100;
                value=accBefore+diffAcc*p; 
                return           
            end

            %Error-Handling
            value=0;
        end
    end
end

