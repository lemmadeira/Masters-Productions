# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Função Objetivo
										
/* minimize FO:    Sbase * sum{y in Y} (sum{(t,s) in SC} 365*Dt*Prob[t,s]*( 1 / ((1 + TD)^(y-1)))*( sum{(i,j) in B} (CostE[t,s]*R[i,j]*I2[y,i,j,t,s]*1e-3)))
				+ sum{i in CB}(Ccbf*Ncbf[i]) + sum{i in CB}(Ccb*Ncb_max[i]) + sum{i in PV}(Cpv*Npv[i]) ;*/ /* + CostEmi*fatEmi */		
				
minimize FO:    Sbase*365*Dt * sum{y in Y} ( 1 / ((1 + TD)^(y-1))) * (sum{(t,s) in SC} Prob[t,s]*(((CostE[t,s] + CostEmi*fatEmi)*PS[y,1,t,s]*1e-3) + (C_Fuel + C_GD_OeM + CostEmi*fatEmiGD)*sum{i in GD}(Pgd[i,t]*1e-3) + C_PV_OeM*sum{i in PV}(Ppv_ds[i,t,s]*1e-3)))
				+ sum{i in CB}(Cfcb*Nfcb[i]) + sum{i in BB}(Cbb*Nsae[i]) + sum{i in CB}(Cscb*Nscb_max[i]) + sum{i in PV}(Cpv*Npv[i]) + sum{i in GD}(Cgd*Ngd[i])
				+ 1e4 * sum{y in Y}( (Sbase/Vbase)*(sum {(i,j) in B}sum{(t,s) in SC}(1e4*I2pen[y,i,j,t,s]))   +   (Sbase)*(sum{i in N}( sum {(t,s) in SC}(QSpen_folga[y,i,t,s] + QSpen_excesso[y,i,t,s] + V2pen_folga[y,i,t,s] + V2pen_excesso[y,i,t,s] + S2pen[y,i,t,s])))  );				

# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Fluxo de Potência
										
subject to balanco_potencia_P {y in Y, i in N, (t,s) in SC}:
	sum {(j,i) in B} P[y,j,i,t,s] - sum {(i,j) in B} (P[y,i,j,t,s] + I2[y,i,j,t,s]*R[i,j]) + PS[y,i,t,s] = PD[i]*FD[t,s]*FatDem[y] + locEV[i,y]*dEV[t]             			 - Ppv_ds[i,t,s] - Ppv_in[i,t,s] - Pgd[i,t] + PsaeC[i,t] - PsaeD[i,t]; 

subject to balanco_potencia_Q  {y in Y, i in N, (t,s) in SC}:
	sum {(j,i) in B} Q[y,j,i,t,s] - sum {(i,j) in B} (Q[y,i,j,t,s] + I2[y,i,j,t,s]*X[i,j]) + QS[y,i,t,s] = QD[i]*FD[t,s]*FatDem[y] + locEV[i,y]*qEV[t] + Qscb[i,t] + Qfcb[i] - Qpv_ds[i,t,s] - Qpv_in[i,t,s] - Qgd[i,t];						
	
subject to res_03 {y in Y, (i,j) in B, (t,s) in SC }:
	V2[y,i,t,s] - V2[y,j,t,s] = 2*(P[y,i,j,t,s]*R[i,j] + Q[y,i,j,t,s]*X[i,j]) + I2[y,i,j,t,s]*Z2[i,j];

subject to res_06 {y in Y, (i,j) in B, (t,s) in SC }:
	V2[y,j,t,s]*I2[y,i,j,t,s] >= P[y,i,j,t,s]^2 + Q[y,i,j,t,s]^2; # NL
	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Limites de Operação

subject to fator_potencia_SE01 {y in Y, i in N, (t,s) in SC: Tb[i] == 1}:
	QS[y,i,t,s] - QSpen_folga[y,i,t,s] <= PS[y,i,t,s]*tan(acos(FPminInd));
	
subject to fator_potencia_SE02 {y in Y, i in N, (t,s) in SC: Tb[i] == 1}:
	QS[y,i,t,s] + QSpen_excesso[y,i,t,s] >= -PS[y,i,t,s]*tan(acos(FPminCap));
	
subject to res_Tensao {y in Y, i in N, (t,s) in SC}:
	Vmin^2 <= V2[y,i,t,s] - V2pen_folga[y,i,t,s] + V2pen_excesso[y,i,t,s] <= Vmax^2;

subject to res_Corrente {y in Y, (i,j) in B, (t,s) in SC}:
	I2[y,i,j,t,s] - I2pen[y,i,j,t,s] <= Imax[i,j]^2;

subject to res_SS {y in Y, i in N, (t,s) in SC: Tb[i] == 1}:
	PS[y,i,t,s]^2 + QS[y,i,t,s]^2 - S2pen[y,i,t,s] <= SMAX[i]^2;				# NL*/


	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Alocação de Capacitores Fixos
 
subject to FCB01_alocacao {i in CB}:
	Qfcb[i] = Nfcb[i]*qcb;
	
subject to FCB02_alocacao {i in CB}:
	0 <= Nfcb[i] <= NMC;
	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Alocação de Capacitores Chaveados

subject to SCB01_alocacao {i in CB, t in PER}:
	Qscb[i,t] = Nscb[i,t]*qcb;
	
subject to SCB02_alocacao {i in CB}:
	Nscb_max[i] <= NMC;

subject to SCB03_operacao {i in CB, t in PER}:
	Nscb[i,t] <= Nscb_max[i];
	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Alocação de Sistemas de Armazenamento - Norberto

subject to SAE00_alocacao {i in BB}:
	Nsae[i] <= NMB;

subject to SAE01_alocacao {i in BB, t in PER}:
	PsaeD[i,t] <= Nsae[i]*Psae_max;
	
subject to SAE02_alocacao {i in BB, t in PER}:
	PsaeC[i,t] <= Nsae[i]*Psae_max;
			
subject to SAE03_operacao {i in BB, t in PER:t>0}:
	Esae[i,t] = Esae[i,t-1] + Dt*(Sbase*eta_sae*PsaeC[i,t] - Sbase*PsaeD[i,t]/eta_sae - beta_sae*Esae[i,t]);
	
subject to SAE04_operacao {i in BB}:
	Esae[i,0] = Esae[i,card(PER)-1] + Dt*(Sbase*eta_sae*PsaeC[i,0] - Sbase*PsaeD[i,0]/eta_sae - beta_sae*Esae[i,0]);

subject to SAE05_operacao {i in BB, t in PER}:
	Esae_min*Nsae[i] <= Esae[i,t];
	
subject to SAE06_operacao {i in BB, t in PER}:
	Esae[i,t] <= Esae_max*Nsae[i];
					

# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  || 

										## Alocação de Geradores Fotovoltaicos

subject to PV00_alocacao {i in PV}:
	Npv[i] <= NMPV;		
		
subject to PV01_alocacao {i in PV, (t,s) in SC}:
	Ppv_ds[i,t,s] <= Npv[i]*PNpv*fatGer[t,s];
	
subject to PV02_alocacao {i in PV, (t,s) in SC}:
	Ppv_ds[i,t,s]^2 + Qpv_ds[i,t,s]^2 <= Npv[i]*Spv_ds;
	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  || 

										## Operação de Geradores Fotovoltaicos

subject to PV01_operacao {i in PV, (t,s) in SC}:
	Ppv_in[i,t,s] = Npv[i]*PNpv*fatGer[t,s];
	
subject to PV02_operacao01 {i in PV, (t,s) in SC}:
	V2[5,i,t,s] - V2_1 <= M*(1 - alpha1[i,t,s]);

subject to PV02_operacao02 {i in PV, (t,s) in SC}:
	V2_1 - V2[5,i,t,s] <= M*(1 - alpha2[i,t,s]);

subject to PV02_operacao03 {i in PV, (t,s) in SC}:
	V2[5,i,t,s] - V2_2 <= M*(1 - alpha2[i,t,s]);

subject to PV02_operacao04 {i in PV, (t,s) in SC}:
	V2_2 - V2[5,i,t,s] <= M*(1 - alpha3[i,t,s]);

subject to PV02_operacao05 {i in PV, (t,s) in SC}:
	V2[5,i,t,s] - V2_3 <= M*(1 - alpha3[i,t,s]);

subject to PV02_operacao06 {i in PV, (t,s) in SC}:
	V2_3 - V2[5,i,t,s] <= M*(1 - alpha4[i,t,s]);

subject to PV02_operacao07 {i in PV, (t,s) in SC}:
	V2[5,i,t,s] - V2_4 <= M*(1 - alpha4[i,t,s]);

subject to PV02_operacao08 {i in PV, (t,s) in SC}:
	V2_4 - V2[5,i,t,s] <= M*(1 - alpha5[i,t,s]);

subject to PV03_operacao {i in PV, (t,s) in SC}:
	alpha1[i,t,s] + alpha2[i,t,s] + alpha3[i,t,s] + alpha4[i,t,s] + alpha5[i,t,s] = 1;
	
subject to PV04_operacao01 {i in PV, (t,s) in SC}:
	Qpv_in_1[i,t,s] = Qpv_max*alpha1[i,t,s];
	
subject to PV05_operacao01 {i in PV, (t,s) in SC}:
	Qpv_in_2[i,t,s] <= 3.73*Qpv_max*alpha2[i,t,s];
	
subject to PV05_operacao02 {i in PV, (t,s) in SC}:
	Qpv_in_2[i,t,s] >= 5.02*Qpv_min*alpha2[i,t,s];
	
subject to PV05_operacao03 {i in PV, (t,s) in SC}:
	Qpv_in_2[i,t,s] <= Qpv_max + omega1*ajust1*(V2[5,i,t,s] - V2_1) - 5.02*Qpv_min*(1 - alpha2[i,t,s]);
	
subject to PV05_operacao04 {i in PV, (t,s) in SC}:
	Qpv_in_2[i,t,s] >= Qpv_max + omega1*ajust1*(V2[5,i,t,s] - V2_1) - 3.73*Qpv_max*(1 - alpha2[i,t,s]);
	
subject to PV06_operacao01 {i in PV, (t,s) in SC}:
	Qpv_in_4[i,t,s] <= 3.60*Qpv_max*alpha4[i,t,s];
	
subject to PV06_operacao02 {i in PV, (t,s) in SC}:
	Qpv_in_4[i,t,s] >= 4.20*Qpv_min*alpha4[i,t,s];
	
subject to PV06_operacao03 {i in PV, (t,s) in SC}:
	Qpv_in_4[i,t,s] <= Qpv_min + omega2*ajust2*(V2[5,i,t,s] - V2_4) - 4.20*Qpv_min*(1 - alpha4[i,t,s]);
	
subject to PV06_operacao04 {i in PV, (t,s) in SC}:
	Qpv_in_4[i,t,s] >= Qpv_min + omega2*ajust2*(V2[5,i,t,s] - V2_4) - 3.60*Qpv_max*(1 - alpha4[i,t,s]);
	
subject to PV07_operacao01 {i in PV, (t,s) in SC}:
	Qpv_in_5[i,t,s] = Qpv_min*alpha5[i,t,s];
	
subject to PV08_operacao01 {i in PV, (t,s) in SC}:
	Qpv_in[i,t,s] = Qpv_in_1[i,t,s] + Qpv_in_2[i,t,s] + Qpv_in_4[i,t,s] + Qpv_in_5[i,t,s];
	
#falta restrição de limite de Spv_in
	

# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Alocação de Geradores Despacháveis

subject to GD00_alocacao {i in GD}:
	Ngd[i] <= NMGD; 

subject to GD01_alocacao {i in GD}:
	Sgd[i] = Ngd[i]*SgdMAX; 		
		
subject to GD02_operacao {i in GD, t in PER}:
	Pgd[i,t]^2 + Qgd[i,t]^2 <= Sgd[i]^2; 
	
subject to GD03_operacao {i in GD, t in PER}:
	Qgd[i,t] <= Pgd[i,t] * tan(acos(FPgd));
	
subject to GD04_operacao {i in GD, t in PER}:
	-Pgd[i,t] * tan(acos(FPgd)) <= Qgd[i,t];
