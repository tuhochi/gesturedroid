clear all
data=load('2010.12.09.12.32.16.txt');
treshold=0.5;
windowSize=5;
% Zeit von nsec in sec umrechnern



data(:,1)=data(:,1)./1000000000;
originaldata=data;
% cal data laden
calibrationdata = getcalibrateData('n1.txt');
% calibrate data
caldata=calibrate(data,calibrationdata,treshold);

data=data(:,2:4);
caldata=caldata(:,2:4);



%x=filter(ones(1,windowSize)/windowSize,1,caldata);
%data=x;


d(:,1)=originaldata(:,1);
d(:,2:4)=data(:,1:3);
d(:,5:7)=originaldata(:,5:7)
data=d;
%break;

% Beschleunigungs-Daempfung in % / pro Sekunde
daempfung=0.99;% 0.99^60 = 0.547156642

distance = zeros(size(data,1),3);
velocity = zeros(size(data,1),3);

acc=data(:,2:4);
down=data(:,5:7).*9.81;
down(:,3)=-9.81;
down(:,1:2)=0;


deltatime=data(:,1)


% Erdbeschleunigung abgezogen
real=acc+down;
%real=acc;

%real=filter(ones(1,windowSize)/windowSize,1,real);
real(real(:,1)<treshold & real(:,1)>-treshold ,1)=0;
real(real(:,2)<treshold & real(:,2)>-treshold ,2)=0;
real(real(:,3)<treshold & real(:,3)>-treshold ,3)=0;

%real=real(windowSize*2:end-(windowSize*2),:);

% real(:,1)=real(:,1)-mean(real(:,1));
% real(:,2)=real(:,2)-mean(real(:,2));
% real(:,3)=real(:,3)-mean(real(:,3))



positionTX=[0 0 0];%Anfangs Position
velocityTX=[0 0 0];%Anfangs Geschwindigkeit
% First
% velocityTX = real(1,:).*deltatime(1)+velocityT0
% distanceTX= real(1,:).*0.5*deltatime(1)^2+(velocityT0.*deltatime(1))+distanceT0
% 
% distance(1,:)=distanceTX;
% velocity(1,:)=velocityTX;


for i=1:size(real,1);
    
    velocityT0=velocityTX;
    positionT0=positionTX;
    
    disp(['---- ',num2str(i),' ---']);
    velocityTX = real(i,:).*deltatime(i)+velocityT0
    positionTX = real(i,:).*0.5*deltatime(i)^2+(velocityT0.*deltatime(i))+positionT0
    
    velocityTX=velocityTX*nthroot(daempfung, round(1/deltatime(i)));% zeitlich gewichtete Daempfung (xte[1/deltatime] Wurzel aus Daempfung
    
    distance(i,:)=positionTX;
    velocity(i,:)=velocityTX;
    
end

%i=round(size(distance,1)/4);

figure;
grid on;
axis square;
hold on;

xlabel('x')
ylabel('y')
zlabel('z')
h=hsv(size(distance,1));


for i=1:size(distance,1)-1
    plot3(distance(i:i+1,1),distance(i:i+1,2),distance(i:i+1,3),'--o','Color',h(i,:));
    %text(distance(i+1,1),distance(i+1,2),distance(i+1,3),num2str(i+1));
end


 hold off
time=sum(data(:,1))