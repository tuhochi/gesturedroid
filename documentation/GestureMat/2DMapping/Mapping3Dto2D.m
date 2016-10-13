%Testfunktion
t=0:pi/20:5*pi;
x=t(1:end).*sin(t(1:end));
y=t(1:end).*cos(t(1:end));
z=t;
M=[x' y' z'];

%Startpunkt & Endpunkt
direction=[M(1,:);M(end,:)];

%Anzeigen der Ausgangsfunktion
figure
plot3(x,y,z)
title('Ausgangsfunktion');
xlabel('x');ylabel('y');zlabel('z');

%Richtung der Kurve
hold on
line(direction(:,1),direction(:,2),direction(:,3),'Color','r');
hold off

%Stuenzpunkte
n=100;

%Berechnung der Winkeln für Rotation
[axis angle]=rotateVecToZ(direction(2,:));

%Rotieren des Richtungsvektors
vRot=rotateV(direction(2,:),axis(1),angle(1));
vRot=rotateV(vRot,axis(2),angle(2));

%Anzeigen der rotierten Funktion
figure
%Koordinatensystem
line([0 2],[0 0],[0 0],'Color','cyan');
line([0 0],[0 2],[0 0],'Color','cyan');
line([0 0],[0 0],[0 2],'Color','cyan');
line([0 -2],[0 0],[0 0],'Color','cyan');
line([0 0],[0 -2],[0 0],'Color','cyan');
line([0 0],[0 0],[0 -2],'Color','cyan');
line([0 vRot(1)],[0 vRot(2)],[0 vRot(3)],'Color','red');
xlabel('x');ylabel('y');zlabel('z');
title('Richtungsvektor zu z-Achse gedreht')
hold on

%Rotation aller Punkte
for i=1:size(M,1)
    %Rotieren
    for j=1:size(axis,1)
        M(i,:)=rotateV(M(i,:),axis(j),angle(j));
    end
end
plot3(M(:,1),M(:,2),M(:,3))
hold off

%Berechnung der 2D-Ebene
N=[M(:,1) M(:,2)];

%Entfernen von doppelten Punkten
[Nunique, m2, n2] = unique(N,'first','rows');

figure
line([0 2],[0 0],[0 0],'Color','cyan');
line([0 0],[0 2],[0 0],'Color','cyan');
line([0 0],[0 0],[0 2],'Color','cyan');
line([0 -2],[0 0],[0 0],'Color','cyan');
line([0 0],[0 -2],[0 0],'Color','cyan');
line([0 0],[0 0],[0 -2],'Color','cyan');
%plot(Nunique(:,1),Nunique(:,2));
plot(N(:,1),N(:,2));
xlabel('x');ylabel('y');zlabel('z');
title('2D-Plot der gedrehten Funktion')