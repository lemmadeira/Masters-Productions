%Distribucion de los VE en la red de distribucion a lo largo del horizonte
%de planeamiento
%nV_0 Number of EVs at the beginning of the planning horizon
%nEVN Number of EVs per node at the planning period t and year y
%nEVS Total number of EVs in the system at the planning period t and year y

function [nV_0,nEVN,nEVS]=EV_Penetration(t,y,N,u)

    u = 0;
    % t = 1; %  Número de períodos de planejamento
    % y = 1; %  Anos do horizonte de planejamento
    %u: uncertainty about the year of full EV penetration
    ny=5; %planning period duration

    %% Gerando a curva S

    xi=2014; % year of EV appereance 
    u=normrnd(0,u);
    xf=2085+u; %year of full EV penetration 
    a=2024; %Ano atual
    p=0.005; %Penetracao estimada atual
    pf=1.00; %Penetracao maxima
    x1=a-xi;
    x2=(xf-xi)/2;
    coef=linsolve([x1^3 x1^2;x2^3 x2^2],[p;pf/2]); 
    f=@(x) (x<=x2).*(coef(1)*x.^3+coef(2)*x.^2)+(x>x2).*(pf-coef(1)*(2*x2-x).^3-coef(2)*(2*x2-x).^2); %Curva S 

    % %Grafico
    % x=(xi:0.1:xf);
    % p=f(x-xi);
    % plot(x,p)
    % xlabel('Year','FontSize',12,'FontName','Times')
    % ylabel('EV penetration','FontSize',12,'FontName','Times')
    % axis([xi xf -0.2 1.2])
    % grid on

    %% Cantidad de VE

    nVp=0.50; %numero per capita de veiculos   
    CEp=2500; %consumo eletrico anual percapita (kWh)
    fda=0.69; %Anual demand factor
    CE_N=fda*N(:,3)*1000*24*365; %Annual consumption of each node at year 0
    nV_0=round(nVp/CEp*CE_N); %Estimated number of vehicles for each node at year 0
    r=0.05; %Annual vehicle growth rate 
    nV=nV_0*(1+r*(ny*(t-1)+y));
    pEV=f(ny*(t-1)+y+x1);
    nEVN=round(nV.*pEV); %EV nodal number
    nEVS=sum(nEVN);

end


