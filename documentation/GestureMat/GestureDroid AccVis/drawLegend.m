function [] = drawLegend(lineProperty,handles,axe)
%DRAWLEGEND Summary of this function goes here
%   Detailed explanation goes here

switch axe;
    case 'classAcc'
        f=figure(1);
    case 'acc'
        f=figure(2);
    case 'featureClassMode'
        f=figure(3);
    case 'featureMode'
        f=figure(4);
    otherwise
end

t=size(lineProperty,2);
xPos = 1/(6+1):1/(6+1):1-(1/(6+1));
yPos = 1-1/(floor((t+1)/2)+1):-1/(floor((t+1)/2)+1):1/(floor((t+1)/2)+1);

indexY=1;% Index der y Position, wird in jedem 2 Druchlauf erhoeht
for i=1:size(lineProperty,2)% pro Durchlauf wreden jeweils xyz gezeichnet
    
    spX = mod(i+1,2)*0.5+0.1;% Start Position X, also entweder 0.1 oder 0.5
    
    channels=lineProperty(i).channels{1};
    
    if channels==3
        %3 Farben
        text(spX,yPos(indexY),[lineProperty(i).line{1} ' x' num2str(i)],'Color',lineProperty(i).r{1})
        text(spX+0.12,yPos(indexY),[lineProperty(i).line{1} ' y' num2str(i)],'Color',lineProperty(i).g{1})
        text(spX+0.26,yPos(indexY),[lineProperty(i).line{1} ' z' num2str(i)],'Color',lineProperty(i).b{1})
    else
        %1 Farbe
        text(spX,yPos(indexY),[lineProperty(i).line{1} ' FeatureValue' num2str(i)],'Color',lineProperty(i).b{1})
       
    end
    
    if(mod(i,2)==0)indexY=indexY+1;end
end

end

