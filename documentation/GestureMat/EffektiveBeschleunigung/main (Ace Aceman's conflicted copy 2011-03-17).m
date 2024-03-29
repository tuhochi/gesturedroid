%Testfile
file='training/1golf/2010.12.08.23.28.08.txt';
file1='training/1golf/2010.12.08.23.28.30.txt';
file2='training/1golf/2010.12.08.23.28.51.txt';
file3='training/1golf/2010.12.08.23.29.55.txt';
file4='training/1golf/2010.12.08.23.30.20.txt';

%Laden der relativen Beschleunigungswerte
data1=load(file);
data1=[data1(:,1)./1000000000 data1(:,2) data1(:,3) data1(:,4)];
data2=load(file1);
data2=[data2(:,1)./1000000000 data2(:,2) data2(:,3) data2(:,4)];
data3=load(file2);
data3=[data3(:,1)./1000000000 data3(:,2) data3(:,3) data3(:,4)];
data4=load(file3);
data4=[data4(:,1)./1000000000 data4(:,2) data4(:,3) data4(:,4)];
data5=load(file4);
data5=[data5(:,1)./1000000000 data5(:,2) data5(:,3) data5(:,4)];

%Zeitlinie hinzufügen
timeLine(1)=data(1,1);
for i=2:size(data,1)
    timeLine(i)=timeLine(i-1)+data(i,1);
end
timeLine=timeLine';

%Nur Beschleunigungsdaten
data1=[data1(:,2),data1(:,3),data1(:,4)];
%data1=max(abs(data1(:,:)'))';
%plot(data1);
data2=[data2(:,2),data2(:,3),data2(:,4)];
data3=[data3(:,2),data3(:,3),data3(:,4)];
data4=[data4(:,2),data4(:,3),data4(:,4)];
data5=[data5(:,2),data5(:,3),data5(:,4)];
figure
hold on
%Nur Achsen
features=buildFeatureVector(data1,'3Achsen',timeLine);
features=buildFeatureVector(data2,'3Achsen',timeLine);
features=buildFeatureVector(data3,'3Achsen',timeLine);
features=buildFeatureVector(data4,'3Achsen',timeLine);
features=buildFeatureVector(data5,'3Achsen',timeLine);


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






