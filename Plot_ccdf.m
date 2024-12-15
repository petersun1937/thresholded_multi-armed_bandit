
x=0:1:20000;
Q1 = marcumq(5*15,sqrt(x));
figure
plot(0.5*log2(x+1),Q1)
hold on
Q2 = marcumq(17*7,sqrt(x));
plot(0.5*log2(x+1),Q2)
Q3 = marcumq(18*2,sqrt(x));
plot(0.5*log2(x+1),Q3)
%}

%{
x=0:0.01:200;
Q1 = marcumq(5/15,sqrt(x));
figure
plot(0.5*log2((15^2+15^2/2)*x+1),Q1)
hold on
Q2 = marcumq(17/7,sqrt(x));
plot(0.5*log2((7^2+7^2/2)*x+1),Q2)
Q3 = marcumq(18/2,sqrt(x));
plot(0.5*log2((2^2+2^2/2)*x+1),Q3)
%}