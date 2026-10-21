%Calcula o CDF da SOC inicial (antes do carregamento)

function [freqA,freq]=SOC_freq(v)

    M=1e3;  %Numero de simulacoes
    N=1e3;  %Número de dias consecutivos de cada simulación
    soc=zeros(M*N,1);
    for i=1:M
        soc_i=rand;
        s=N*(i-1);
        for j=1:N
            soc(s+j)=soc_i;
            soc_i=SOC_day(soc_i,v);
        end
    end
    %histogram(soc);
    edges=0:0.01:1;
    freq = histcounts(soc,edges)/(M*N); % PDF soc inicial
    soc_m=(0.005:0.01:0.995)';
    freqA=zeros(100,1);
    freqA(1)=freq(1);
    for j=2:100
        freqA(j)=freqA(j-1)+freq(j);
    end
    freqA=[soc_m freqA]; % CDF SOC inicial

    % probSOCini(1) = freqA(1,2);
    % for i=2:1:100
    %     probSOCini(i) = freqA(i,2) - freqA(i-1,2);
    % end
    % plot(1:100,probSOCini)

end