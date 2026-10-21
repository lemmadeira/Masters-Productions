%Calculo y grafico de la curva de carga diversificada para un EV a traves
%de simulaciones de Montecarlo
%Considera distribucion de vehículos según nível de carga (80%-1,20%-2)

function D_EV=Diversified_EVUnit()

    fev1=0.8; %Participation of EV level 1
    fev2=0.2; %Participation of EV level 2
    ns=1e6; %Numero de simulacoes
    d1=zeros(ns,24);
    d2=zeros(ns,24);
    freq1=SOC_freq(1); %Frequencia acumulada do SOC ao inicio do carregamento con v1
    freq2=SOC_freq(2); %Frequencia acumulada do SOC ao inicio do carregamento con v2
    for j=1:ns
        d1(j,:)=d1(j,:)+EVUnit(1,freq1);
        d2(j,:)=d2(j,:)+EVUnit(2,freq2);
    end
    D=fev1*d1+fev2*d2;
    D_EV=mean(D);

    Dr=quantile(D,0.95);
    %Grafico
    Dm=D_EV;
    Dm(25)=Dm(24);
    i=(0:24);
    figure
    stairs(i,Dm,'LineWidth',1.5)
    grid on
    xlim([0 24]);
    xticks(4:4:24);
    ytickformat('%,.2f');
    ax=gca;
    ax.FontSize=14;
    ax.FontName='Times';
    ylabel('Demanda Diversificada (kW)')
    xlabel('Hora (h)')
    set(gcf, 'units','normalized','outerposition',[0 0 0.5 0.55]);
    set(gcf,'Color','w');
    set(gcf, 'Renderer', 'painters');
    exportgraphics(gcf, 'EVdiversified.png', 'Resolution', 600);
    % export_fig Fig1.pdf -painters
    % disp(sum(D_EV));
    
end

   
