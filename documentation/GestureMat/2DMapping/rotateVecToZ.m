function [axis angle] = rotateVecToZ(v)
%ROTATEVECTOZ Summary of this function goes here
%   Detailed explanation goes here

rad2deg=180/pi;
deg2rad=pi/180;
l=norm(v);

%Punkt liegt im Ursprung
if (v(1)==0 && v(2)==0 && v(3)==0)
    axis='x';
    angle=0;
    return
end

%Punkt liegt auf einer Achse
if ((v(2)==0 && v(3)==0) || (v(1)==0 && v(3)==0) || (v(1)==0 && v(2)==0))
    
    %Punkt liegt auf der x-Achse
    if (v(2)==0 && v(3)==0)
        if(v(1)>0)
            axis='y';
            angle=360-90;
        else
            axis='y';
            angle=90;
        end
    end

    %Punkt liegt auf der y-Achse
    if (v(1)==0 && v(3)==0)
        if(v(2)>0)
            axis='x';
            angle=90;
        else
            axis='x';
            angle=360-90;
        end
    end

    %Punkt liegt auf z-Achse
    if (v(1)==0 && v(2)==0)
        if(v(3)>0)
            axis='z';
            angle=0;
        else
            axis='x';
            angle=180;
        end
    end
    
    figure
    %Koordinatensystem
    line([0 v(1)],[0 v(2)],[0 v(3)],'Color','r');
    line([0 2],[0 0],[0 0],'Color','cyan');
    line([0 0],[0 2],[0 0],'Color','cyan');
    line([0 0],[0 0],[0 2],'Color','cyan');
    line([0 -2],[0 0],[0 0],'Color','cyan');
    line([0 0],[0 -2],[0 0],'Color','cyan');
    line([0 0],[0 0],[0 -2],'Color','cyan');
    xlabel('x');ylabel('y');zlabel('z');
    title('Richtungsvektor wird zu z-Achse gedreht')
    hold on

    %Rotation in z-Achse
    vRot=rotateV(v,axis,angle);
    line([0 vRot(1)],[0 vRot(2)],[0 vRot(3)],'Color','black');

    hold off
    return
end

%Punkt liegt in den 4 unteren Quadranten
if(v(3)<0)
    
    %Punkt liegt auf der linken Seite
    if(v(1)<0)
        %Punkt liegt vorne
        if(v(2)<0)
            alphaOffSet=-360;
            betaOffSet=0;
        %Punkt liegt hinten
        else
            alphaOffSet=-360;
            betaOffSet=0;
        end
    
    %Punkt liegt auf der rechten Seite    
    else
        %Punkt liegt vorne
        if(v(2)<0)
            alphaOffSet=0;
            betaOffSet=0;
        %Punkt liegt hinten
        else
            alphaOffSet=0;
            betaOffSet=0;
        end
        
    end
    
%Punkt liegt in den oberen Quadranten
else
    
    %Punkt liegt auf der linken Seite
    if(v(1)<0)
        %Punkt liegt vorne
        if(v(2)<0)
            alphaOffSet=-360;
            betaOffSet=0;
        %Punkt liegt hinten
        else
            alphaOffSet=-360;
            betaOffSet=0;
        end
    
    %Punkt liegt auf der rechten Seite    
    else
        %Punkt liegt vorne
        if(v(2)<0)
            alphaOffSet=0;
            betaOffSet=0;
        %Punkt liegt hinten
        else
            alphaOffSet=0;
            betaOffSet=0;
        end
        
    end
    
end

%Normieren des Vektors
vN=v./norm(v);

%Vektor v auf yz-Ebene abbilden v'=(x,y,0)
%Winkel alpha zur z-Achse (0,0,1) bestimmen
% d= sqrt(y²+z²)
d=sqrt(vN(1)^2+vN(2)^2);
alpha=acos(vN(2)/d);
alphaDEG=alpha*rad2deg;


%Vektor v auf xz-Ebene abbilden v'=(x,0,z)
%Winkel beta zur z-Achse (0,0,1) bestimmen
% d= sqrt(x²+z²)
%d=sqrt(vN(1)^2+vN(3)^2);
%beta=2*pi-asin(vN(1)/d);
%betaDEG=360-acos(vN(3)/d)*rad2deg;
betaDEG=acos(vN(3))*rad2deg;

figure
%Koordinatensystem
line([0 v(1)],[0 v(2)],[0 v(3)],'Color','r');
line([0 2],[0 0],[0 0],'Color','cyan');
line([0 0],[0 2],[0 0],'Color','cyan');
line([0 0],[0 0],[0 2],'Color','cyan');
line([0 -2],[0 0],[0 0],'Color','cyan');
line([0 0],[0 -2],[0 0],'Color','cyan');
line([0 0],[0 0],[0 -2],'Color','cyan');
xlabel('x');ylabel('y');zlabel('z');
title('Richtungsvektor wird zu z-Achse gedreht')
hold on

%Betrachten des entsprechenden Quadranten
alphaDEG=alphaDEG+alphaOffSet;
betaDEG=betaDEG+betaOffSet;

alphaDEG=abs(alphaDEG);
betaDEG=abs(betaDEG);

%1.Rotation in die yz-Ebene
vRot=rotateV(v,'z',alphaDEG);
line([0 vRot(1)],[0 vRot(2)],[0 vRot(3)],'Color','b');

%2.Rotation zu z-Achse
vRotY=rotateV(vRot,'x',betaDEG);
line([0 vRotY(1)],[0 vRotY(2)],[0 vRotY(3)],'Color','black');

hold off

axis=['z';'x'];
angle=[alphaDEG;betaDEG];


end

