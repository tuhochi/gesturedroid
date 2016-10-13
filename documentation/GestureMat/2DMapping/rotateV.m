function [rotatedV] = rotateV(v,axis,angle)
%ROTATEV Summary of this function goes here
%   Detailed explanation goes here

%Umrechnung
rad2deg=180/pi;
deg2rad=pi/180;

switch axis
    case 'x'
        %Rotation um die x-Achse
        rotatedV(1)=v(1);
        rotatedV(2)=v(2)*cos(angle*deg2rad)-v(3)*sin(angle*deg2rad);
        rotatedV(3)=v(2)*sin(angle*deg2rad)+v(3)*cos(angle*deg2rad);
        
    case 'y'
        %Rotation um die y-Achse
        rotatedV(1)=v(3)*sin(angle*deg2rad)+v(1)*cos(angle*deg2rad);
        rotatedV(2)=v(2);
        rotatedV(3)=v(3)*cos(angle*deg2rad)-v(1)*sin(angle*deg2rad);
        
    case 'z'
        %Rotation um die z-Achse
        rotatedV(1)=v(1)*cos(angle*deg2rad)-v(2)*sin(angle*deg2rad);
        rotatedV(2)=v(1)*sin(angle*deg2rad)+v(2)*cos(angle*deg2rad);
        rotatedV(3)=v(3);
    otherwise
        %Falscher Input
        disp('Keine gültige Rotationsachse!')
        rotatedV=v;
end
        
end

