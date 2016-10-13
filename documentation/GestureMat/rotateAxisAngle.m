function [axis angle] = rotateAxisAngle(v1,v2)
%ROTATEAXISANGLE Summary of this function goes here
%   Detailed explanation goes here

rad2deg=180/pi;
deg2rad=pi/180;

axis=cross(v1,v2);
phi=dot(v1,v2)/(norm(v1)*norm(v2));

angle=acos(phi)*rad2deg;

disp(['Achse: ' num2str(axis) ' Winkel: ' num2str(angle)])
end

