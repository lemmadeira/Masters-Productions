clear all

horizonte = 1;

ev1 = 28;
year = [5 10 15 20];
ev = importdata("EV.txt");
for i=1:1:4
    EV(:,i) = [ev(1:35,i+1);ev(1:34,i+6)];
    soma(i) = sum(EV(:,i));
    perEV(:,i) = EV(:,i)/soma(i);
end
nos = length(EV(:,1));
for i=1:1:nos
    perEVnew(i,1) = mean(perEV(i,:));
end
evy = [(soma(1) - ev1)/(year(1) - 1) ev1-(soma(1) - ev1)/(year(1) - 1)];
EVfinal(1:nos,1:horizonte) = 0;
for i=1:1:horizonte
    EVnew(:,i) = perEVnew*(evy(1)*i+evy(2));
    linha = 1;
    for j=1:1:nos
        if EVnew(j,i)>=1
            EVfinal(j,i) = floor(EVnew(j,i));
            EVnew(j,i) = EVnew(j,i) - EVfinal(j,i);
        end
        if sum(EVnew(linha:j,i))>=1
            linhaNew = randi([linha j]);
            EVfinal(linhaNew,i) = EVfinal(linhaNew,i) + 1;
            linha = j + 1;
        end
    end
end
EVfinal


