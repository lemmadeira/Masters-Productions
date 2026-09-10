# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Função Objetivo
										
/* minimize FO:    Sbase * sum{y in Y} (sum{(t,s) in SC} 365*Dt*Prob[t,s]*( 1 / ((1 + TD)^(y-1)))*( sum{(i,j) in B} (CostE[t,s]*R[i,j]*I2[y,i,j,t,s]*1e-3)))
				+ sum{i in CB}(Ccbf*Ncbf[i]) + sum{i in CB}(Ccb*Ncb_max[i]) + sum{i in PV}(Cpv*Npv[i]) ;*/ /* + CostEmi*fatEmi */		
minimize FO:    Sbase*365*Dt * sum{y in Y} ( 1 / ((1 + TD)^(y-1))) * (sum{(t,s) in SC} Prob[t,s]*(((CostE[t,s] + CostEmi*fatEmi)*PS[y,1,t,s]*1e-3) + (C_Fuel + C_GD_OeM + CostEmi*fatEmiGD)*sum{i in GD}(Pgd[i,t,s]*1e-3) + C_PV_OeM*sum{i in PV}(Ppv[i,t,s]*1e-3)))
				+ sum{i in CB}(Ccbf*Ncbf[i]) + sum{i in BB}(Cbb*Nsae[i]) + sum{i in CB}(Ccb*Ncb_max[i]) + sum{i in PV}(Cpv*Npv[i]) + sum{i in GD}(Cgd*Ngd[i]);				


# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Fluxo de Potência
										
subject to balanco_potencia_P {y in Y, i in N, (t,s) in SC}:
	sum {(j,i) in B} P[y,j,i,t,s] - sum {(i,j) in B} (P[y,i,j,t,s] + I2[y,i,j,t,s]*R[i,j]) + PS[y,i,t,s] = PD[i]*FD[t,s]*FatDem[y] + locEV[i,y]*dEV[t]             			   - Ppv[i,t,s] - Pgd[i,t,s] + PsaeC[i,t,s] - PsaeD[i,t,s]; 	

subject to balanco_potencia_Q  {y in Y, i in N, (t,s) in SC}:
	sum {(j,i) in B} Q[y,j,i,t,s] - sum {(i,j) in B} (Q[y,i,j,t,s] + I2[y,i,j,t,s]*X[i,j]) + QS[y,i,t,s] = QD[i]*FD[t,s]*FatDem[y] + locEV[i,y]*qEV[t] + Qcb[i,t,s] + Qcbf[i] 			    + Qgd[i,t,s]; 							
	
subject to res_03 {y in Y, (i,j) in B, (t,s) in SC }:
	V2[y,i,t,s] - V2[y,j,t,s] = 2*(P[y,i,j,t,s]*R[i,j] + Q[y,i,j,t,s]*X[i,j]) + I2[y,i,j,t,s]*Z2[i,j];

subject to res_06 {y in Y, (i,j) in B, (t,s) in SC }:
	V2[y,j,t,s]*I2[y,i,j,t,s] >= P[y,i,j,t,s]^2 + Q[y,i,j,t,s]^2; # NL
	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Limites de Operação

subject to fator_potencia_SE01 {y in Y, i in N, (t,s) in SC: Tb[i] == 1}:
	QS[y,i,t,s] <= PS[y,i,t,s]*tan(acos(FPminInd));
	
subject to fator_potencia_SE02 {y in Y, i in N, (t,s) in SC: Tb[i] == 1}:
	QS[y,i,t,s] >= -PS[y,i,t,s]*tan(acos(FPminCap));
	
subject to res_Tensao {y in Y, i in N, (t,s) in SC}:
	Vmin^2 <= V2[y,i,t,s] <= Vmax^2;

subject to res_Corrente {y in Y, (i,j) in B, (t,s) in SC}:
	I2[y,i,j,t,s] <= Imax[i,j]^2;

subject to res_SS {y in Y, i in N, (t,s) in SC: Tb[i] == 1}:
	PS[y,i,t,s]^2 + QS[y,i,t,s]^2 <= SMAX[i]^2;				# NL
	
/* subject to res_Teste {y in Y,i in N, (t,s) in SC: Tb[i] == 1}:
	PS[y,i,t,s]>=0.0001; */
	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Alocação de Capacitores Fixos

subject to res_capacitoresF01 {i in CB}:
	Qcbf[i] = Ncbf[i]*qcb;
	
subject to res_capacitoresF02 {i in CB}:
	0 <= Ncbf[i] <= NMC;
	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Alocação de Capacitores Chaveados

subject to res_capacitoresC01 {i in CB, (t,s) in SC}:
	Qcb[i,t,s] = Ncb[i,t,s]*qcb;
	
subject to res_capacitoresC02 {i in CB, (t,s) in SC}:
	Ncb[i,t,s] <= Ncb_max[i];
	
subject to res_capacitoresC03 {i in CB, (t,s) in SC}:
	0 <= Ncb_max[i] <= NMC;
	
subject to res_capacitoresC04 {i in CB, t in PER, s in Scen:s<card(Scen)}:
	Ncb[i,t,s] = Ncb[i,t,s+1];
	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Alocação de Sistemas de Armazenamento - Yumbla 2024

subject to res_SAE01_02 {i in BB, (t,s) in SC}:
	PsaeD[i,t,s] <= Nsae[i]*Psae_max;
	
subject to res_SAE02_02 {i in BB, (t,s) in SC}:
	PsaeC[i,t,s] <= Nsae[i]*Psae_max;
			
subject to res_SAE03_01 {i in BB, t in PER:t>0}:
	Esae[i,t] = Esae[i,t-1] + Dt*(Sbase*eta_sae*PsaeC[i,t,1] - Sbase*PsaeD[i,t,1]/eta_sae - beta_sae*Esae[i,t]);
	
subject to res_SAE03_02 {i in BB}:
	Esae[i,0] = Esae[i,card(PER)-1] + Dt*(Sbase*eta_sae*PsaeC[i,0,1] - Sbase*PsaeD[i,0,1]/eta_sae - beta_sae*Esae[i,0]);

subject to res_SAE04_01 {i in BB, t in PER}:
	Esae_min*Nsae[i] <= Esae[i,t];
	
subject to res_SAE04_02 {i in BB, t in PER}:
	Esae[i,t] <= Esae_max*Nsae[i];
	
subject to res_SAE05 {i in BB, t in PER, s in Scen:s<card(Scen)}:
	PsaeC[i,t,s] = PsaeC[i,t,s+1];
	
subject to res_SAE06 {i in BB, t in PER, s in Scen:s<card(Scen)}:
	PsaeD[i,t,s] = PsaeD[i,t,s+1];
	
/* subject to res_SAE07 {i in BB, t in PER, s in Scen:s<card(Scen)}:
	Esae[i,t,s] = Esae[i,t,s+1]; */
			
			
			
			
			
/* subject to res_SAE00 {i in BB}:
	Psae_max_var[i] = Nsae[i]*Psae_max;
	
subject to res_SAE01_02 {i in BB, (t,s) in SC}:
	PsaeD[i,t,s] <= x_sae[i]*Psae_max_var[i];
	
subject to res_SAE02_02 {i in BB, (t,s) in SC}:
	PsaeC[i,t,s] <= (1 - x_sae[i])*Psae_max_var[i];
			
subject to res_SAE03_01 {i in BB, s in Scen, t in PER:t>0}:
	Esae[i,t,s] = Esae[i,t-1,s] + Dt*(Sbase*eta_sae*PsaeC[i,t,s] - Sbase*PsaeD[i,t,s]/eta_sae - beta_sae*Esae[i,t,s]);
	
subject to res_SAE03_02 {i in BB, s in Scen}:
	Esae[i,0,s] = Esae[i,card(PER)-1,s] + Dt*(Sbase*eta_sae*PsaeC[i,0,s] - Sbase*PsaeD[i,0,s]/eta_sae - beta_sae*Esae[i,0,s]);

subject to res_SAE04_01 {i in BB, (t,s) in SC}:
	Esae_min <= Esae[i,t,s];
	
subject to res_SAE04_02 {i in BB, (t,s) in SC}:
	Esae[i,t,s] <= Esae_max;
	
subject to res_SAE05 {i in BB, t in PER, s in Scen:s<card(Scen)}:
	PsaeC[i,t,s] = PsaeC[i,t,s+1];
	
subject to res_SAE06 {i in BB, t in PER, s in Scen:s<card(Scen)}:
	PsaeD[i,t,s] = PsaeD[i,t,s+1];
	
subject to res_SAE07 {i in BB, t in PER, s in Scen:s<card(Scen)}:
	Esae[i,t,s] = Esae[i,t,s+1]; */

# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  || 

										## Alocação de Geradores Fotovoltaicos
										
subject to res_PV01 {i in PV, (t,s) in SC}:
	Ppv[i,t,s] = Npv[i]*PNpv*fatGer[t,s];

# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Alocação de Geradores Despacháveis

subject to res_GD00 {i in GD}:
	Sgd[i] = Ngd[i]*SgdMAX;; 		
		
subject to res_GD01 {i in GD, (t,s) in SC}:
	Pgd[i,t,s]^2 + Qgd[i,t,s]^2 <= Sgd[i]^2; 
	
subject to res_GD02 {i in GD, (t,s) in SC}:
	Qgd[i,t,s] <= Pgd[i,t,s] * tan(acos(FPgd));
	
subject to res_GD03 {i in GD, (t,s) in SC}:
	-Pgd[i,t,s] * tan(acos(FPgd)) <= Qgd[i,t,s];
	
subject to res_GD04 {i in GD, t in PER, s in Scen:s<card(Scen)}:
	Pgd[i,t,s] = Pgd[i,t,s+1];
	
subject to res_GD05 {i in GD, t in PER, s in Scen:s<card(Scen)}:
	Qgd[i,t,s] = Qgd[i,t,s+1];
