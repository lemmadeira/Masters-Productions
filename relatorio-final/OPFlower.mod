
# 										LOWER LEVEL

										## Objective Function: Operational costs
											
maximize FOlower:    Sbase*365*Dt * sum{y in Y} (( 1 / ((1 + TD)^(y-1))) * (sum{(t,ss) in SC} Prob[t,ss]*( 
															+ sum{i in PVin}(Ppv_in[i,t,ss]*1e-3 * CostE_PV)
															- sum{i in PVin}(Ppv_in[i,t,ss]*1e-3 * CostPV_OeM)
															)))
				+ sum{i in PVin}(PNpv_in[i]*CostGov)
				- sum{y in Y} ( 1 / ((1 + TD)^(y-1))) * (sum{i in PVin}(Ptotal[i]*1e-3 * CostUse))
				- sum{i in PVin}(PNpv_in[i]*CostConnec)
				- sum{i in PVin}(Cpv*Npv_in[i])
				;							

# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  || 

										## PV allocation

subject to PVIN01_alocation {i in PVin}
	Npv_in[i] <= NMPV;

subject to PVIN02_alocation {i in PVin}
	PNpv_in[i] = Npv_in[i]*Ppv_mod;

subject to PVIN03_alocation {i in PVin}
	PNpv_in[i] <= Ptotal[i];

subject to PVIN04_alocation {i in PVin, (t,ss) in SC}
	Ppv_in[i,t,ss] = PNpv_in*fatGer[t,ss]; # Vai ser resolvido usando restrições de vizinhança?


# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  || 

#										## Batterie Allocation: model from Norberto
#
#subject to SAE01_alocacao {i in BB}:
#	Nsae[i] <= NMB;
#
#subject to SAE02_alocacao {i in BB, t in PER}:
#	PsaeD[i,t] <= Nsae[i]*Psae_max;
#	
#subject to SAE03_alocacao {i in BB, t in PER}:
#	PsaeC[i,t] <= Nsae[i]*Psae_max;
#			
#subject to SAE01_operacao {i in BB, t in PER:t>0}:
#	Esae[i,t] = Esae[i,t-1] + Dt*(Sbase*eta_sae*PsaeC[i,t] - Sbase*PsaeD[i,t]/eta_sae - beta_sae*Esae[i,t]);
#	
#subject to SAE02_operacao {i in BB}:
#	Esae[i,0] = Esae[i,card(PER)-1] + Dt*(Sbase*eta_sae*PsaeC[i,0] - Sbase*PsaeD[i,0]/eta_sae - beta_sae*Esae[i,0]);
#
#subject to SAE03_operacao {i in BB, t in PER}:
#	Esae_min*Nsae[i] <= Esae[i,t];
#	
#subject to SAE04_operacao {i in BB, t in PER}:
#	Esae[i,t] <= Esae_max*Nsae[i];
#					

	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  || 

#										## Volt Var Control for PVs
#	
#/* subject to PV01_operacao {i in PVin, (t,ss) in SC}:
#	-Ppv_in[i,t,ss] * tan(acos(FPpv)) <= Qpv_in[i,t,ss] <= Ppv_in[i,t,ss]*tan(acos(FPpv)); */
#
#subject to PV01_operacao {y in Y,i in PVin, (t,ss) in SC}:
#	Qpv_in[y,i,t,ss] = Qdisp[i,t,ss]*Npv_in[y,i,t,ss];
#	
#subject to PV02_operacao {y in Y,i in PVin, (t,ss) in SC}:
#	Npv_in_ngbh[y,i,t,ss] - k_pv_in[y,i,t,ss] <= Npv_in[y,i,t,ss] <= Npv_in_ngbh[y,i,t,ss] + k_pv_in[y,i,t,ss];
#	
#/* subject to PV02_operacao {i in PVin, (t,ss) in SC}:
#	Ppv_in[i,t,ss]^2 + Qpv_in[i,t,ss]^2 <= Spv_in^2; */	# Não necessário pois Qmax=0.44Pn
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
/* subject to PV03_operacao {y in Y, i in PVin, (t,ss) in SC}:
    -Qdisp[i,t,ss] <= Qpv_in[y,i,t,ss] <= Qdisp[i,t,ss];

subject to PV04_operacao {y in Y, i in PVin,(t,ss) in SC}:
  sum{r in VR} a[r,y,i,t,ss] = 1;

subject to PV05_operacao {r in VR,y in Y, i in PVin,(t,ss) in SC}:
  theta[r,y,i,t,ss] <= a[r,y,i,t,ss];

subject to PV06_operacao {y in Y, i in PVin,(t,ss) in SC}:
  V2[y,i,t,ss] = sum{r in 0..tr-1} (a[r,y,i,t,ss] * Vp_ext[r] + theta[r,y,i,t,ss] * (Vp_ext[r+1] - Vp_ext[r]));

subject to PV07_operacao {y in Y, i in PVin,(t,ss) in SC}:
  Qpv_in[y,i,t,ss] = sum{r in 0..tr-1} (a[r,y,i,t,ss] * Qdisp[i,t,ss] * Qp_ext[r] + theta[r,y,i,t,ss] * Qdisp[i,t,ss] *(Qp_ext[r+1] - Qp_ext[r])); */
	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  || 

										## Alocação de Geradores Despacháveis

/* subject to GD01_alocacao {i in GD}:
	Ngd[i] <= NMGD; 

subject to GD02_alocacao {i in GD}:
	Sgd[i] = Ngd[i]*SgdMAX; 		
		
subject to GD03_operacao {i in GD, t in PER}:
	Pgd[i,t]^2 + Qgd[i,t]^2 <= Sgd[i]^2; 
	
subject to GD04_operacao {i in GD, t in PER}:
	-Pgd[i,t] * tan(acos(FPgd)) <= Qgd[i,t];	
	
subject to GD05_operacao {i in GD, t in PER}:
	Qgd[i,t] <= Pgd[i,t] * tan(acos(FPgd)); */
	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  || 


# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  || 

										## Alocação de Geradores Fotovoltaicos

/* subject to PV01_alocacao {i in PVds}:
	Npv[i] <= NMPV;		
		
subject to PV02_alocacao {i in PVds, (t,ss) in SC}:
	Ppv_ds[i,t,ss] <= Npv[i]*PNpv_ds*fatGer[t,ss];
	
subject to PV03_alocacao {i in PVds, (t,ss) in SC}:
	Ppv_ds[i,t,ss]^2 + Qpv_ds[i,t,ss]^2 <= (Npv[i]*Spv_ds)^2;

subject to PV04_alocacao {i in PVds, (t,ss) in SC}:
	-Ppv_ds[i,t,ss] * tan(acos(FPpv)) <= Qpv_ds[i,t,ss];
	
subject to PV05_alocacao {i in PVds, (t,ss) in SC}:
	Qpv_ds[i,t,ss] <= Ppv_ds[i,t,ss] * tan(acos(FPpv));
 */



































										## Operação de Geradores Fotovoltaicos

/* subject to PV01_operacao {i in PV, (t,s) in SC}:
	Ppv_in[i,t,s] <= PNpv_in*fatGer[t,ss];
	
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

	










