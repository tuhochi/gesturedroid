ordner='training';

%LabelingStructur
labelingStruct={'1golf';
                '2baseball';
                '3sword';
                '4hammer';
                '5wave';};

%TrainingsDaten einlesen
ordnerListing=dir(ordner);
ordnerSize=size(ordnerListing,1);

TrainingSet3Achsen=[];
TrainingSetEffektiv=[];

TrainingSetEffektivM=[];
TrainingSetEffektivZ=[];
TrainingSetEffektivZU=[];

TrainingSetEffektivNM=[];
TrainingSetEffektivNZ=[];
TrainingSetEffektivNZU=[];

TrainingSetEffektivNormiert=[];
TrainingSet3AchsenNormiert=[];
TrainingSet3AchsenSkaliertM=[];
TrainingSet3AchsenSkaliertZ=[];
TrainingSet3AchsenSkaliertZU=[];
TrainingSet3AchsenNormiertSkaliertM=[];
TrainingSet3AchsenNormiertSkaliertZ=[];
TrainingSet3AchsenNormiertSkaliertZU=[];

LabelSet=[];
%Alle Unterordner
for i=3:ordnerSize
    
    %Klasse
    class=ordnerListing(i,1).name;
    
    %Label zur Klasse finden
    label=find(ismember(labelingStruct(:,1), class)==1);

    %Alle Dateien eines Ordners
    fileListing=dir([ordner '/' class]);

    %Alle Messungen betrachten
    for j=3:size(fileListing,1);
        
        %File
        readFile=fileListing(j,1).name;
        file=[ordner '/' class '/' readFile];
        
        %Laden der relativen Beschleunigungswerte
        data=load(file);
        data=[data(:,1)./1000000000 data(:,2) data(:,3) data(:,4)];
        
        %Zeitlinie hinzufügen
        timeLine(1)=data(1,1);
        for k=2:size(data,1)
            timeLine(k)=timeLine(k-1)+data(k,1);
        end
        timeLine=timeLine';

        %Nur Beschleunigungsdaten
        data=[data(:,2),data(:,3),data(:,4)];
        
        %Features berechnen 
%         features=buildFeatureVector(data,'3Achsen',timeLine);
%         TrainingSet3Achsen=[TrainingSet3Achsen; features(:,1)' features(:,2)' features(:,3)'];
%         
%         features=buildFeatureVector(data,'effektiv',timeLine);
%         TrainingSetEffektiv=[TrainingSetEffektiv; features];
%         
%         features=buildFeatureVector(data,'effektiv+normiert',timeLine);
%         TrainingSetEffektivNormiert=[TrainingSetEffektivNormiert; features];
%         
%         features=buildFeatureVector(data,'3Achsen+normiert',timeLine);
%         TrainingSet3AchsenNormiert=[TrainingSet3AchsenNormiert; features(:,1)' features(:,2)' features(:,3)'];
        
        features=buildFeatureVector(data,'3Achsen+skaliertMesspunkt',timeLine);
        TrainingSet3AchsenSkaliertM=[TrainingSet3AchsenSkaliertM; features(:,1)' features(:,2)' features(:,3)'];
        
        %Effektivwert
        features=buildFeatureVector(features,'effektiv',timeLine);
        TrainingSetEffektivM=[TrainingSetEffektivM; features];
        
        features=buildFeatureVector(data,'3Achsen+skaliertZeit(normal)',timeLine);
        TrainingSet3AchsenSkaliertZ=[TrainingSet3AchsenSkaliertZ; features(:,1)' features(:,2)' features(:,3)'];
        
        %Effektivwert
        features=buildFeatureVector(features,'effektiv',timeLine);
        TrainingSetEffektivZ=[TrainingSetEffektivZ; features];
        
        features=buildFeatureVector(data,'3Achsen+skaliertZeit(überlappend)',timeLine);
        TrainingSet3AchsenSkaliertZU=[TrainingSet3AchsenSkaliertZU; features(:,1)' features(:,2)' features(:,3)'];
        
        %Effektivwert
        features=buildFeatureVector(features,'effektiv',timeLine);
        TrainingSetEffektivZU=[TrainingSetEffektivZU; features];
        
        features=buildFeatureVector(data,'3Achsen+normiert+skaliertMesspunkt',timeLine);
        TrainingSet3AchsenNormiertSkaliertM=[TrainingSet3AchsenNormiertSkaliertM; features(:,1)' features(:,2)' features(:,3)'];
        
        %Effektivwert
        features=buildFeatureVector(features,'effektiv',timeLine);
        TrainingSetEffektivNM=[TrainingSetEffektivNM; features];
        
        features=buildFeatureVector(data,'3Achsen+normiert+skaliertZeit(normal)',timeLine);
        TrainingSet3AchsenNormiertSkaliertZ=[TrainingSet3AchsenNormiertSkaliertZ; features(:,1)' features(:,2)' features(:,3)'];
        
        %Effektivwert
        features=buildFeatureVector(features,'effektiv',timeLine);
        TrainingSetEffektivNZ=[TrainingSetEffektivNZ; features];
        
        features=buildFeatureVector(data,'3Achsen+normiert+skaliertZeit(überlappend)',timeLine);
        TrainingSet3AchsenNormiertSkaliertZU=[TrainingSet3AchsenNormiertSkaliertZU; features(:,1)' features(:,2)' features(:,3)'];
        
        %Effektivwert
        features=buildFeatureVector(features,'effektiv',timeLine);
        TrainingSetEffektivNZU=[TrainingSetEffektivNZU; features];
        
        LabelSet=[LabelSet; label];
    end

end

%Speichern der Labelings
save LabelStruct labelingStruct;
%Speichern des TrainingsSets
save('TrainingSet',...
     'TrainingSet3AchsenSkaliertM','TrainingSetEffektivM',...
     'TrainingSet3AchsenSkaliertZ','TrainingSetEffektivZ',...
     'TrainingSet3AchsenSkaliertZU','TrainingSetEffektivZU',...
     'TrainingSet3AchsenNormiertSkaliertM','TrainingSetEffektivNM',...
     'TrainingSet3AchsenNormiertSkaliertZ','TrainingSetEffektivNZ',...
     'TrainingSet3AchsenNormiertSkaliertZU','TrainingSetEffektivNZU',...
     'LabelSet');

