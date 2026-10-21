
function D=EVUnit(v,soc_freq)
    %v=1 para nível de carga 1
    %v=2 para nível de carga 2
    %Caracteísticas del VE (ref: Nissan Leaf)
    k=40; %Capacidade da bateria (kWh)
    %d=225; %Recorrido maximo (km)
    cev=0.195; %Consumo do EV (kWh/km)
    %Velocidade de carga
    v1=2.2; %level 1 (kW)
    v2=12.2; %level 2 (kW)
    n=0.85; %eficiencia de carregamento
    %Recorrido promedio diario
    r=35; %km
    SOC_min=r*cev/k; %capacidade mínima requerida
    %Set SOC
    D=zeros(1,24);
    if v==1
        %Geração aleatoria do SOC ao inicio de carregamento de acordo com CDF-SOC 
        x=rand;
        c=0;
        i=1;
        while c==0
            if x<=soc_freq(i,2)
                SOC=soc_freq(i,1);
                c=1;
            else
                i=i+1;
            end
        end
        f=[8,7,2,2,2,3,5,5,5,7,7,7,7,7,7,7,7,7,8,9,10,10,10,9];
        f=f/sum(f);

        %CDF EV1
        cf=zeros(1,25);
        c=0;
        for i=1:24
            cf(i)=c+f(i);
            c=cf(i);
        end

        %Geração aleatoria do horario de inicio de carregamento de acordo com
        %CDF-HORARIO
        x1=rand;
        v=0;
        i=1;
        while v==0
            if x1<=cf(i)
                y=i;
                v=1;
            else
                i=i+1;
            end
        end
        %Deteminación de la curva de carga horaria V1
        p_c=1*(SOC<=0.20)+(1.3077-1.5385*SOC)*((SOC>0.20)&&(SOC<=0.85));
        a=rand;
        if a<p_c
            if SOC<SOC_min
                min_tc=ceil(k*(SOC_min-SOC)/(v1*n));
            else
                min_tc=0;
            end
            max_tc=ceil(k*(1-SOC)/(v1*n));
            tc=min_tc+randi(max_tc-min_tc);
            for j=1:tc
                if y+j-1>24
                   y=2-j;
                end
                D(y+j-1)=v1;
            end
        end
    end

    if v==2
        %Geração aleatoria do SOC ao inicio de carregamento de acordo com CDF-SOC 
        x=rand;
        c=0;
        i=1;
        while c==0
            if x<=soc_freq(i,2)
                SOC=soc_freq(i,1);
                c=1;
            else
                i=i+1;
            end
        end
        f=[0,0,0,0,0,0,0,0,7,7,7,7,7,7,7,7,7,7,4,4,3,3,2,0];
        f=f/sum(f);

        %CDF EV2
        cf=zeros(1,25);
        c=0;
        for i=1:24
            cf(i)=c+f(i);
            c=cf(i);
        end

        %Geração aleatoria do horario de inicio de carregamento de acordo com CDF-Horario 
        x1=rand;
        v=0;
        i=1;
        while v==0
            if x1<=cf(i)
                y=i;
                v=1;
            else
                i=i+1;
            end
        end
        %Deteminación de la curva de carga horaria V2
        p_c=1*(SOC<=0.20)+(1.3077-1.5385*SOC)*((SOC>0.20)&&(SOC<=0.85));
        a=rand;
        if a<p_c
            if SOC<SOC_min
                min_tc=ceil(k*(SOC_min-SOC)/(v2*n));
            else
                min_tc=0;
            end
            max_tc=ceil(k*(1-SOC)/(v2*n));
            tc=min_tc+randi(max_tc-min_tc);
            j=1;
            while j<=tc
                if y+j-1>23
                   j=tc+1;
                else
                    D(y+j-1)=v2;
                    j=j+1;
                end
            end
        end
    end
end

