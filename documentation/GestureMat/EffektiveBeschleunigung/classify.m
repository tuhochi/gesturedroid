function [label] = classify(featureVector,kNN, featureVectorMode)
%CLASSIFYEFFACC Summary of this function goes here
%   Detailed explanation goes here

%Permutation
permutation=1;

%labelSet
%LabelSet;

switch featureVectorMode
    %jweils richitiges TrainingSet laden
    case 'normiert+skaliert'
        trainingSet;
        dist=getFeatureDistance(featureVector,trainingSet,3,permutation);
        
        if permutation==1
            %Distanzmatrix sortieren
        end
        
        [value,index]=min(dist);
        label=LabelSet(index);
         
    case 'normiert+skaliert(normal)'
        trainingSet;
        dist=getFeatureDistance(featureVector,trainingSet,3,permutation);
        
        if permutation==1
            %Distanzmatrix sortieren
        end
        
        [value,index]=min(dist);
        label=LabelSet(index);
        
    case 'normiert+skaliert(überlappend)'
        trainingSet;
        dist=getFeatureDistance(featureVector,trainingSet,3,permutation);
        
        if permutation==1
            %Distanzmatrix sortieren
        end
        
        [value,index]=min(dist);
        label=LabelSet(index);
        
    case 'skaliert'
        trainingSet;
        dist=getFeatureDistance(featureVector,trainingSet,3,permutation);
        
        if permutation==1
            %Distanzmatrix sortieren
        end
        
        [value,index]=min(dist);
        label=LabelSet(index);
        
    case 'skaliert(normal)'
        trainingSet;
        dist=getFeatureDistance(featureVector,trainingSet,3,permutation);
        
        if permutation==1
            %Distanzmatrix sortieren
        end
        
        [value,index]=min(dist);
        label=LabelSet(index);
        
    case 'skaliert(überlappend)'
        trainingSet;
        dist=getFeatureDistance(featureVector,trainingSet,3,permutation);
        
        if permutation==1
            %Distanzmatrix sortieren
        end
        
        [value,index]=min(dist);
        label=LabelSet(index);
        
    case 'effektiv+skaliert'
        trainingSet;
        dist=getFeatureDistance(featureVector,trainingSet,1,0);

        [value,index]=min(dist);
        label=LabelSet(index);
        
    case 'effektiv+normiert+skaliert'
        trainingSet;
        dist=getFeatureDistance(featureVector,trainingSet,1,0);

        [value,index]=min(dist);
        label=LabelSet(index);
        
    otherwise
    disp('Fehler: Unbekannter Mode');
    label=0;
end

end

