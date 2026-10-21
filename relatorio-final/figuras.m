clear all
clc
close all

lambda = 0:0.1:1;

% hc01 =   [4.89638 4.89638 6.94207 7.72168 8.40902 9.10462 9.57069 10.3603 10.9122 11.3611 11.5702]; %VVC
% cost01 = [6142810 6245450 6596200 6981800 7009990 7375630 7845590 8126990 8213570 8422880 9583110]/10^6;
% 
% hc02 =   [4.89141 6.01348 7.49478 8.62598 9.33465 9.99585 10.6306 11.2134 11.2134 12.0447 12.2563]; %BB
% cost02 = [5886910 6201420 7093290 7477150 7727480 8155880 8551850 8638900 8596150 9119920 9816490]/10^6;
% 
% hc03 =   [4.89529 6.02573 7.49681 8.58397 9.33399 9.99337 10.6273 11.2113 11.7586 12.0427 12.2543]; %BB + VVC
% cost03 = [5908740 6625370 7225280 7450790 7916390 7946620 8218280 8467920 8895820 8909300 9812990]/10^6;
% 
% %hc02 =   []; %BB + VVC
% %cost02 = []/10^6;
% 
% figure
% set(groot, 'defaultAxesFontName', 'Times New Roman');
% set(groot, 'defaultAxesFontSize', 11);
% set(groot, 'defaultTextFontName', 'Times New Roman');
% set(groot, 'defaultTextFontSize', 11);
% plot(cost01,hc01,cost02,hc02,cost03,hc03)
% %axis([6.3 7.5 4 7.5])
% legend('VVC','BB','VVC + BB','Location','southeast')
% xlabel('Costs (10^6) $')
% ylabel('Hosting Capacity (MW)')
% grid on


hc01 =   [5.19758 5.61057 6.16957 7.14254 7.94929 9.81104 11.7866]; %VVC
cost01 = [6753690 6806640 6892690 7221850 7567410 8358140 9303740]/10^6;

figure
set(groot, 'defaultAxesFontName', 'Times New Roman');
set(groot, 'defaultAxesFontSize', 11);
set(groot, 'defaultTextFontName', 'Times New Roman');
set(groot, 'defaultTextFontSize', 11);
plot(cost01,hc01)
%axis([6.3 7.5 4 7.5])
xlabel('Costs (10^6) $')
ylabel('Hosting Capacity (MW)')
grid on









