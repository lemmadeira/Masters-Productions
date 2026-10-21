clear all;
close all;
clc;

cenarios = importdata("cenarios_final.txt");
nper = cenarios.data(end,1);
hpc = 24/nper;

dEV = Diversified_EVUnit();

% Sample data (replace with your actual data)
hours = 0:1:23;
cont = 0;
for i=1:2:47
    cont = cont + 1;
    cost1(cont) = cenarios.data(i,3);    
    cost2(cont) = cenarios.data(i+1,3);  

    load1(cont) = cenarios.data(i,4);  
    load2(cont) = cenarios.data(i+1,4);

    solar1(cont) = cenarios.data(i,5);  
    solar2(cont) = cenarios.data(i+1,5);

    prob1(cont) = cenarios.data(i,6);  
    prob2(cont) = cenarios.data(i+1,6);

end

%% Create the figure with subplots
figure;

set(groot, 'defaultAxesFontName', 'Times New Roman');
set(groot, 'defaultAxesFontSize', 5);
set(groot, 'defaultTextFontName', 'Times New Roman');
set(groot, 'defaultTextFontSize', 5);

% a) Cost
subplot(4,1,1);
plot(hours, cost1, 'b-', 'LineWidth', 0.75); hold on;
plot(hours, cost2, 'b--', 'LineWidth', 0.75);
ylabel('a) Custos ($/MWh)');
legend('Cenário I', 'Cenário II', 'Location', 'northeast');
xlim([0 23]);
xticks(0:2:22);
grid on;

% b) Load level
subplot(4,1,2);
plot(hours, load1, 'b-', 'LineWidth', 0.75); hold on;
plot(hours, load2, 'b--', 'LineWidth', 0.75);
ylabel({'b) Fator de','Demanda (p.u.)'});
xlim([-0.5 23]);
xticks(0:2:22);
grid on;

% c) Solar radiation
subplot(4,1,3);
plot(hours, solar1, 'b-', 'LineWidth', 0.75); hold on;
plot(hours, solar2, 'b--', 'LineWidth', 0.75);
ylabel({'c) Irradiação','Solar (W/m^2)'});
xlim([0 23]);
xticks(0:2:22);
grid on;

% d) Scenario occurrence probability
subplot(4,1,4);
bar(hours, [prob1' prob2'], 'stacked');
ylabel({'d) Probabilidade de Ocorrência','de Cada Cenário (p.u.)'});
xlabel('Hora');
legend('Cenário I', 'Cenário II');
xlim([-0.4 23.4]);
xticks(0:2:22);
grid on;

set(gcf, 'Renderer', 'painters');
exportgraphics(gcf, 'my_figure.png', 'Resolution', 600);