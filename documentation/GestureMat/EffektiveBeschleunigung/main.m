%Testfile
file='training/4hammer/2010.12.08.23.36.35.txt';

%Laden der relativen Beschleunigungswerte
data=load(file);
data=[data(:,1)./1000000000 data(:,2) data(:,3) data(:,4)];

%Zeitlinie hinzufügen
timeLine(1)=data(1,1);
for i=2:size(data,1)
    timeLine(i)=timeLine(i-1)+data(i,1);
end
timeLine=timeLine';

%Nur Beschleunigungsdaten
data=[data(:,2),data(:,3),data(:,4)];

%Nur Achsen
features=buildFeatureVector(data,'3Achsen',timeLine);

%Effektivwert
features=buildFeatureVector(data,'effektiv',timeLine);

%Effektivwert mit normierten Beschleunigungswerten
features=buildFeatureVector(data,'effektiv+normiert',timeLine);

%Beschleunigung der Achsen normiert
features=buildFeatureVector(data,'3Achsen+normiert',timeLine);

%Beschleunigung der Achsen normiert und anhand Messpunkte skaliert
features=buildFeatureVector(data,'3Achsen+normiert+skaliertMesspunk',timeLine);

%Beschleunigung der Achsen normiert und anhand Zeit skaliert
features=buildFeatureVector(data,'3Achsen+normiert+skaliertZeit',timeLine);
%features=buildFeatureVector(data,'3Achsen+normiert+skaliertZeit(normal)',timeLine);

%Beschleunigung der Achsen normiert und anhand Zeit skaliert (überlappend)
features=buildFeatureVector(data,'3Achsen+normiert+skaliertZeit(überlappend)',timeLine);

%Beschleunigung der Achsen anhand Messpunkte skaliert
features=buildFeatureVector(data,'3Achsen+skaliertMesspunk',timeLine);

%Beschleunigung der Achsen anhand Zeit skaliert
features=buildFeatureVector(data,'3Achsen+skaliertZeit',timeLine);
%features=buildFeatureVector(data,'3Achsen+skaliertZeit(normal)',timeLine);

%Beschleunigung der Achsen anhand Zeit skaliert (überlappend)
features=buildFeatureVector(data,'3Achsen+skaliertZeit(überlappend)',timeLine);






