f=figure(1);
t=6;



color= 0.3:(1-0.3)/(t-1):1;

typ = struct('line',{'-','.','--',':'});% die verschiedenen Linien Typen
lineProperty = struct('r',{},'g',{},'b',{}, 'line',{})
for i=1:t;
    lineProperty(i).r={[color(i) 0 0]};
    lineProperty(i).g={[0 color(i) 0]};
    lineProperty(i).b={[0 0 color(i)]};
    lineProperty(i).line= {typ(mod(i-1,size(typ,2))+1).line}
    
end


xPos = 1/(6+1):1/(6+1):1-(1/(6+1))
yPos = 1-1/(floor((t+1)/2)+1):-1/(floor((t+1)/2)+1):1/(floor((t+1)/2)+1);


indexY=1;% Index der y Position, wird in jedem 2 Druchlauf erhoeht
for i=1:t% pro Durchlauf wreden jeweils xyz gezeichnet
    
    spX = mod(i+1,2)*0.5+0.1;% Start Position X, also entweder 0.1 oder 0.5
    
    text(spX,yPos(indexY),[lineProperty(i).line{1} ' x' num2str(i)],'Color',lineProperty(i).r{1})
    text(spX+0.12,yPos(indexY),[lineProperty(i).line{1} ' y' num2str(i)],'Color',lineProperty(i).g{1})
    text(spX+0.26,yPos(indexY),[lineProperty(i).line{1} ' z' num2str(i)],'Color',lineProperty(i).b{1})
    
    if(mod(i,2)==0)indexY=indexY+1;end
end