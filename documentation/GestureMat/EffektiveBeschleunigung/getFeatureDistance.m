function [dist] = getFeatureDistance(fMatrix,f2,f1Dim,permutation)
%GETFEATUREDISTANCE Summary of this function goes here
%   Detailed explanation goes here

dist=[];
if nargin<3
    
    %Nur ein Beschleunigungswert
    if f1Dim==1
        f1=fMatrix;
    end
    
    %Beschleunigung in 3 Achsen
    if f1Dim==3
        f1=[fMatrix(:,1) fMatrix(:,2) fMatrix(:,3)];
    end
    
    %Distanz berechnen
    for i=1:size(f2,1)
        dist=[dist; sqrt(sum((f1-f2(i,:)).^2))];
    end
    return
end

if permutation==1
    
    for i=1:6
        
        %Permutation
        switch i
            case 1
               f1=[fMatrix(:,1) fMatrix(:,2) fMatrix(:,3)]; 
            case 2
               f1=[fMatrix(:,1) fMatrix(:,3) fMatrix(:,2)];
            case 3
               f1=[fMatrix(:,2) fMatrix(:,1) fMatrix(:,3)];
            case 4  
               f1=[fMatrix(:,2) fMatrix(:,3) fMatrix(:,1)];
            case 5   
               f1=[fMatrix(:,3) fMatrix(:,1) fMatrix(:,2)];
            case 6   
               f1=[fMatrix(:,3) fMatrix(:,2) fMatrix(:,1)];
        end
        
        %Distanz zu einer Permutation
        distance=[];
        for j=1:size(f2,1)
            distance=[distance sqrt(sum((f1-f2(j,:)).^2))];
        end
        
        dist=[dist; distance];
    end
end

end

