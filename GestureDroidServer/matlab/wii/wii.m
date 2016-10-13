clear all

xp=load('wiiX-.txt');
xm=load('wiiX+.txt');

yp=load('wiiY-.txt');
ym=load('wiiY+.txt');

zp=load('wiiZ-.txt');
zm=load('wiiZ+.txt');

xpd=xp(:,5:7)- repmat(xp(1,5:7,1),size(xp,1),1);
xmd=xm(:,5:7)- repmat(xm(1,5:7,1),size(xm,1),1);

ypd=yp(:,5:7)- repmat(yp(1,5:7,1),size(yp,1),1);
ymd=ym(:,5:7)- repmat(ym(1,5:7,1),size(ym,1),1);

zpd=zp(:,5:7)- repmat(zp(1,5:7,1),size(zp,1),1);
zmd=zm(:,5:7)- repmat(zm(1,5:7,1),size(zm,1),1);

clf



%subplot(1,2,1)
hold on
plot(xpd(1:2800,:))
plot(xmd(1:2800,:))

plot(ypd(1:2800,:))
plot(ymd(1:2800,:))

plot(zpd(1:2800,:))
plot(zmd(1:2800,:))
hold off


%subplot(1,2,2)


