# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Função Objetivo
											
minimize FO:    Sbase*365*Dt * sum{y in Y} (( 1 / ((1 + TD)^(y-1))) * (sum{(t,ss) in SC} Prob[t,ss]*(((CostE[t,ss] + CostEmi*fatEmi)*PS[y,1,t,ss]*1e-3) + (C_Fuel + C_GD_OeM + CostEmi*fatEmiGD)*sum{i in GD}(Pgd[i,t]*1e-3) + C_PV_OeM*sum{i in PVds}(Ppv_ds[i,t,ss]*1e-3))))
				+ sum{i in CB}(Cfcb*Nfcb[i]) + sum{i in CB}(Cscb*Nscb_max[i]) + sum{i in BB}(Cbb*Nsae[i]) + sum{i in PVds}(Cpv*Npv[i]) + sum{i in GD}(Cgd*Ngd[i])
				+ M * sum{y in Y}((sum {(i,j) in B}sum{(t,ss) in SC}(10*I2pen[y,i,j,t,ss]))   +   (sum{i in N}( sum {(t,ss) in SC}(QSpen_folga[y,i,t,ss] + QSpen_excesso[y,i,t,ss] + 10*V2pen_folga[y,i,t,ss] + 10*V2pen_excesso[y,i,t,ss] + S2pen[y,i,t,ss])))  )
				/* + 1e6 * sum{i in PVin, (t,ss) in SC}(k_pv_in[i,t,ss]) */;				

# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Fluxo de Potência
										
subject to balanco_potencia_P {y in Y, i in N, (t,ss) in SC}:
	sum {(j,i) in B} P[y,j,i,t,ss] - sum {(i,j) in B} (P[y,i,j,t,ss] + I2[y,i,j,t,ss]*R[i,j]) + PS[y,i,t,ss] = PD[i]*FD[t,ss]*FatDem[y] + locEV[i,y]*dEV[t]             		  - Pgd[i,t] - Ppv_ds[i,t,ss] - Ppv_in[i,t,ss] + PsaeC[i,t] - PsaeD[i,t]; 

subject to balanco_potencia_Q  {y in Y, i in N, (t,ss) in SC}:
	sum {(j,i) in B} Q[y,j,i,t,ss] - sum {(i,j) in B} (Q[y,i,j,t,ss] + I2[y,i,j,t,ss]*X[i,j]) + QS[y,i,t,ss] = QD[i]*FD[t,ss]*FatDem[y] + locEV[i,y]*qEV[t] + Qscb[i,t] + Qfcb[i] - Qgd[i,t] - Qpv_ds[i,t,ss] - Qpv_in[y,i,t,ss];						
	
subject to res_03 {y in Y, (i,j) in B, (t,ss) in SC }:
	V2[y,i,t,ss] - V2[y,j,t,ss] = 2*(P[y,i,j,t,ss]*R[i,j] + Q[y,i,j,t,ss]*X[i,j]) + I2[y,i,j,t,ss]*Z2[i,j];

subject to res_06 {y in Y, (i,j) in B, (t,ss) in SC }:
	V2[y,j,t,ss]*I2[y,i,j,t,ss] >= P[y,i,j,t,ss]^2 + Q[y,i,j,t,ss]^2; # NL
	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Limites de Operação

subject to operacao01 {y in Y, i in N, (t,ss) in SC: Tb[i] == 1}:
	QS[y,i,t,ss] - QSpen_folga[y,i,t,ss] <= PS[y,i,t,ss]*tan(acos(FPminInd));
	
subject to operacao02 {y in Y, i in N, (t,ss) in SC: Tb[i] == 1}:
	QS[y,i,t,ss] + QSpen_excesso[y,i,t,ss] >= -PS[y,i,t,ss]*tan(acos(FPminCap));
	
subject to operacao03 {y in Y, i in N, (t,ss) in SC}:
	Vmin^2 <= V2[y,i,t,ss] - V2pen_folga[y,i,t,ss] + V2pen_excesso[y,i,t,ss] <= Vmax^2;

subject to operacao04 {y in Y, (i,j) in B, (t,ss) in SC}:
	I2[y,i,j,t,ss] - I2pen[y,i,j,t,ss] <= Imax[i,j]^2;

subject to operacao05 {y in Y, i in N, (t,ss) in SC: Tb[i] == 1}:
	PS[y,i,t,ss]^2 + QS[y,i,t,ss]^2 - S2pen[y,i,t,ss] <= SMAX[i]^2;				# NL 


	
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

subject to SAE01_alocacao {i in BB}:
	Nsae[i] <= NMB;

subject to SAE02_alocacao {i in BB, t in PER}:
	PsaeD[i,t] <= Nsae[i]*Psae_max;
	
subject to SAE03_alocacao {i in BB, t in PER}:
	PsaeC[i,t] <= Nsae[i]*Psae_max;
			
subject to SAE01_operacao {i in BB, t in PER:t>0}:
	Esae[i,t] = Esae[i,t-1] + Dt*(Sbase*eta_sae*PsaeC[i,t] - Sbase*PsaeD[i,t]/eta_sae - beta_sae*Esae[i,t]);
	
subject to SAE02_operacao {i in BB}:
	Esae[i,0] = Esae[i,card(PER)-1] + Dt*(Sbase*eta_sae*PsaeC[i,0] - Sbase*PsaeD[i,0]/eta_sae - beta_sae*Esae[i,0]);

subject to SAE03_operacao {i in BB, t in PER}:
	Esae_min*Nsae[i] <= Esae[i,t];
	
subject to SAE04_operacao {i in BB, t in PER}:
	Esae[i,t] <= Esae_max*Nsae[i];
					
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  || 

										## Alocação de Geradores Fotovoltaicos

subject to PV01_alocacao {i in PVds}:
	Npv[i] <= NMPV;		
		
subject to PV02_alocacao {i in PVds, (t,ss) in SC}:
	Ppv_ds[i,t,ss] <= Npv[i]*PNpv_ds*fatGer[t,ss];
	
subject to PV03_alocacao {i in PVds, (t,ss) in SC}:
	Ppv_ds[i,t,ss]^2 + Qpv_ds[i,t,ss]^2 <= (Npv[i]*Spv_ds)^2;

subject to PV04_alocacao {i in PVds, (t,ss) in SC}:
	-Ppv_ds[i,t,ss] * tan(acos(FPpv)) <= Qpv_ds[i,t,ss];
	
subject to PV05_alocacao {i in PVds, (t,ss) in SC}:
	Qpv_ds[i,t,ss] <= Ppv_ds[i,t,ss] * tan(acos(FPpv));
	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  || 

										## Operação de Geradores Fotovoltaicos
	
/* subject to PV01_operacao {i in PVin, (t,ss) in SC}:
	-Ppv_in[i,t,ss] * tan(acos(FPpv)) <= Qpv_in[i,t,ss] <= Ppv_in[i,t,ss]*tan(acos(FPpv)); */

subject to PV01_operacao {y in Y,i in PVin, (t,ss) in SC}:
	Qpv_in[y,i,t,ss] = Qdisp[i,t,ss]*Npv_in[y,i,t,ss];
	
subject to PV02_operacao {y in Y,i in PVin, (t,ss) in SC}:
	Npv_in_ngbh[y,i,t,ss] - k_pv_in[y,i,t,ss] <= Npv_in[y,i,t,ss] <= Npv_in_ngbh[y,i,t,ss] + k_pv_in[y,i,t,ss];
	
/* subject to PV02_operacao {i in PVin, (t,ss) in SC}:
	Ppv_in[i,t,ss]^2 + Qpv_in[i,t,ss]^2 <= Spv_in^2; */	# Não necessário pois Qmax=0.44Pn
	
	
	
subject to PV03_operacao {y in Y, i in PVin, (t,ss) in SC}:
    -Qdisp[i,t,ss] <= Qpv_in[y,i,t,ss] <= Qdisp[i,t,ss];

subject to PV04_operacao {y in Y, i in PVin,(t,ss) in SC}:
  sum{r in VR} a[r,y,i,t,ss] = 1;

subject to PV05_operacao {r in VR,y in Y, i in PVin,(t,ss) in SC}:
  theta[r,y,i,t,ss] <= a[r,y,i,t,ss];

subject to PV06_operacao {y in Y, i in PVin,(t,ss) in SC}:
  V2[y,i,t,ss] = sum{r in 0..tr-1} (a[r,y,i,t,ss] * Vp_ext[r] + theta[r,y,i,t,ss] * (Vp_ext[r+1] - Vp_ext[r]));

subject to PV07_operacao {y in Y, i in PVin,(t,ss) in SC}:
  Qpv_in[y,i,t,ss] = sum{r in 0..tr-1} (a[r,y,i,t,ss] * Qdisp[i,t,ss] * Qp_ext[r] + theta[r,y,i,t,ss] * Qdisp[i,t,ss] *(Qp_ext[r+1] - Qp_ext[r]));
	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  || 

										## Alocação de Geradores Despacháveis

subject to GD01_alocacao {i in GD}:
	Ngd[i] <= NMGD; 

subject to GD02_alocacao {i in GD}:
	Sgd[i] = Ngd[i]*SgdMAX; 		
		
subject to GD03_operacao {i in GD, t in PER}:
	Pgd[i,t]^2 + Qgd[i,t]^2 <= Sgd[i]^2; 
	
subject to GD04_operacao {i in GD, t in PER}:
	-Pgd[i,t] * tan(acos(FPgd)) <= Qgd[i,t];	
	
subject to GD05_operacao {i in GD, t in PER}:
	Qgd[i,t] <= Pgd[i,t] * tan(acos(FPgd));
	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  || 







































										## Operação de Geradores Fotovoltaicos

/* subject to PV01_operacao {i in PV, (t,s) in SC}:
	Ppv_in[i,t,s] <= PNpv_in*fatGer[t,s];
	
subject to PV02_operacao {i in PV, (t,s) in SC}:
	Qpv_min <= Qpv_in[i,t,s] <= Qpv_max;
	
subject to PV03_operacao {i in PV, (t,s) in SC}:
	Ppv_in[i,t,s]^2 + Qpv_in[i,t,s]^2 <= Spv_in^2;	

subject to PV04_operacao {i in PV, (t,s) in SC}:
	Qpv_in[i,t,s] = Qpv_max*Npv_in[i,t,s];
	
subject to PV05_operacao {i in PV, (t,s) in SC}:
	Npv_in_ngbh[i,t,s] - k_pv_in[i,t,s] <= Npv_in[i,t,s] <= Npv_in_ngbh[i,t,s] + k_pv_in[i,t,s];
	 */
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  || 


/*subject to PV02_operacao01 {i in PV, (t,s) in SC}:
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
	Qpv_in[i,t,s] = Qpv_in_1[i,t,s] + Qpv_in_2[i,t,s] + Qpv_in_4[i,t,s] + Qpv_in_5[i,t,s]; */
	
#falta restrição de limite de Spv_in

	










