function [ output_args ] = carDriver( points )
%CARDRIBER Summary of this function goes here
%   Detailed explanation goes here

%Testfunktion
t=[1 3 5 4 2 0]

x=t(1:end).*sin(t(1:end));
y=t(1:end).*cos(t(1:end));
z=t;
points=[x' y' z'];
%clear t x y z startEnd;

plot3(x,y,z)
xlabel('x');ylabel('y');zlabel('z')

for i=1:size(points,1)
    text(points(i,1),points(i,2),points(i,3),num2str(i));
end


%% Car
%          +y(carUp Vector)
%          ^
%       ______
%   ¬__/__|____\____        --> +z (carFront Vector)
%    [_(X)_\____(X)_]
%
% carFront ist jener Vector der in die Fahrtrichtung zeigt 
carFront=[0 0 1];%
% carUp ist der UP Vector der Autos
carUp=[0 1 0];% anfangs immer in positive y-Richtung, es koennte auch positive z-Richtung angenommen werden, ist dann das Ergebnis um 90 Grad verdreht?
% darauf normal steht die x-Achse des Autos (carSide Vector)
carSide=[1 0 0];%

%% andere Initialierung
carFront=points(2,:)-points(1,:); carFront=carFront./norm(carFront);

carSide=points(3,:)-points(2,:); carSide=carSide./norm(carSide);
carUp=cross(carSide,carFront);carUp=carUp./norm(carUp);
%carSide=cross(carUp,carFront);

%% nun die Berechnung

hold on;

cf=carFront;
cu=carUp;
cs=carSide;

plot3([points(1,1) points(1,1)+carUp(1)]',[points(1,2) points(1,2)+carUp(2)]',[points(1,3) points(1,3)+carUp(3)]','Color','cyan');
plot3([points(1,1) points(1,1)+carSide(1)]',[points(1,2) points(1,2)+carSide(2)]',[points(1,3) points(1,3)+carSide(3)],'Color','red');

for t= 1: size(points,1)-1
    
    % aktueller normierter carFront Vektor der die Fahrtrichtung anzeigt
    carFront=points(t+1,:)-points(t,:); carFront=carFront./norm(carFront);
    
    % aktueller side Vector steht normal auf carFront/carUp
    carSide = cross(carFront,carUp);
    %carSide=carSide./norm(carSide);
    % carUp wird nun aktualisiert, carUp steht normal auf carSide/carFront
    carUp = cross(carSide,carFront);
    
    carUp=carUp./norm(carUp);
    
    plot3([points(t+1,1) points(t+1,1)+carUp(1)]',[points(t+1,2) points(t+1,2)+carUp(2)]',[points(t+1,3) points(t+1,3)+carUp(3)]','Color','green');
    plot3([points(t+1,1) points(t+1,1)+carSide(1)]',[points(t+1,2) points(t+1,2)+carSide(2)]',[points(t+1,3) points(t+1,3)+carSide(3)],'Color','red');
        
    cf=[cf;carFront];
    cu=[cu;carUp];
    cs=[cs;carSide];
   
end
hold off;

%carFront=actualFront;
end

