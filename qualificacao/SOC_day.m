function SOC_f=SOC_day(SOC_i,v)

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
    SOC_min=r*cev/k; %capacidade mínima requerida para o percurso diario
    
    if v==1
        %PDF EV1
        h=zeros(1,25);
        for i=1:25
            h(i)=i-1;
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
           
        %Geração aleatoria do inicio de carregamento de acordo com PDF 
        x=rand;
        v=0;
        i=1;
        while v==0
            if x<=cf(i)
                y=i;
                v=1;
            else
                i=i+1;
            end
        end
        %Deteminación de la probabilidad de carga 
        p_c=1*(SOC_i<=0.20)+(1.3077-1.5385*SOC_i)*((SOC_i>0.20)&&(SOC_i<=0.85));
        a=rand;
        if a<p_c
            if SOC_i<SOC_min
                min_tc=k*(SOC_min-SOC_i)/(v1*n);
            else
                min_tc=1;
            end
            max_tc=k*(1-SOC_i)/(v1*n);
            tc=min_tc+rand*(max_tc-min_tc);
            SOC_f=SOC_i-SOC_min+tc*v1*n/k;
        else
            SOC_f=SOC_i-SOC_min;
        end
    end
    
    if v==2
        %PDF EV2
        h=zeros(1,25);
        for i=1:25
            h(i)=i-1;
        end
        f=[0,0,0,0,0,0,0,0,7,7,7,7,7,7,7,7,7,7,4,4,3,3,2,0];
        f=f/sum(f);
        
        %CDF EV1
        cf=zeros(1,25);
        c=0;
        for i=1:24
            cf(i)=c+f(i);
            c=cf(i);
        end
            
        %Geração aleatoria do inicio de carregamento de acordo com PDF 
        x=rand;
        v=0;
        i=1;
        while v==0
            if x<=cf(i)
                y=i;
                v=1;
            else
                i=i+1;
            end
        end
        %Deteminación de la curva de carga horaria V2
        p_c=1*(SOC_i<=0.20)+(1.3077-1.5385*SOC_i)*((SOC_i>0.20)&&(SOC_i<=0.85));
        a=rand;
        if a<p_c
            if SOC_i<SOC_min
                min_tc=k*(SOC_min-SOC_i)/(v2*n);
            else
                min_tc=0.5;
            end
            max_tc=k*(1-SOC_i)/(v2*n);
            tc=min_tc+rand*(max_tc-min_tc);
            if y+tc-1>23
                tc=24-y;
            end
            SOC_f=SOC_i-SOC_min+tc*v2*n/k;
            %if SOC_f>1
            %    SOC_f=1;
            %end
         else
            SOC_f=SOC_i-SOC_min;
        end
    end

end