
										## Objective Function  
							# 2*1e-3	Sbase			
maximize FO:    		(w)*(1/(15))*( sum{i in PV}Pper[i]) 												#+ 1*1e1*sum{y in Y,(i,j) in B,(t,ss) in SC}(P[y,i,j,t,ss] + Q[y,i,j,t,ss] - I2[y,i,j,t,ss]) - 1*1e1*sum{y in Y,i in N,(t,ss) in SC}(V2[y,i,t,ss]))
						-(1-w)*(1/2250000)*( Sbase*365*Dt * sum{y in Y} (( 1 / ((1 + TD)^(y-1))) * (sum{(t,ss) in SC} Prob[t,ss]*( 
															sum{(i,j) in B}(R[i,j]*I2[y,i,j,t,ss]*1e-3 * CostE_buy[t,ss])
															+ (PS[y,1,t,ss]* 1e-3 *CostE_buy[t,ss])
															- (PSn[y,1,t,ss]* 1e-3 *CostE_buy[t,ss]*0.6)
															+ (CostFuel + CostGD_OeM)*sum{i in GD}(Pgd[i,t]*1e-3)
															+ sum{i in PV}(Phc[i,t,ss]* 1e-3 *CostE_PV) 
															)))
															+ sum{i in CB}(Cfcb*Nfcb[i]) + sum{i in CB}(Cscb*Nscb_max[i]) + sum{i in BB}(Cbb*Nsae[i]) + sum{i in GD}(Cgd*Ngd[i]) )
				#- M *Sbase*365*Dt* sum{y in Y}((sum {(i,j) in B}sum{(t,ss) in SC}(Prob[t,ss]*I2pen[y,i,j,t,ss]))   +   (sum{i in N}( sum {(t,ss) in SC}(Prob[t,ss]*(1*V2pen_folga[y,i,t,ss] + 1000*V2pen_excesso[y,i,t,ss] + 1*S2pen[y,i,t,ss]))))  )
				- c_pen*Sbase*365*Dt* sum{y in Y,(i,j) in B,(t,ss) in SC}(Prob[t,ss]*I2[y,i,j,t,ss])
				#- c_pen*Sbase*365*Dt* sum{y in Y,(i,j) in B,(t,ss) in SC}(Prob[t,ss]*(P[y,i,j,t,ss]^2+Q[y,i,j,t,ss]^2))
				;				

# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Power Flow - Conic model
										
subject to P_balance {y in Y, i in N, (t,ss) in SC}:
	sum {(j,i) in B} P[y,j,i,t,ss] - sum {(i,j) in B} (P[y,i,j,t,ss] + I2[y,i,j,t,ss]*R[i,j]) + PS[y,i,t,ss] - PSn[y,i,t,ss] = PD[i]*FD[t,ss]*FatDem[y] + locEV[i,y]*dEV[t] - Pgd[i,t] - Phc[i,t,ss] + PsaeC[i,t] - PsaeD[i,t] ; 

subject to Q_balance  {y in Y, i in N, (t,ss) in SC}:
	sum {(j,i) in B} Q[y,j,i,t,ss] - sum {(i,j) in B} (Q[y,i,j,t,ss] + I2[y,i,j,t,ss]*X[i,j]) + QS[y,i,t,ss] = QD[i]*FD[t,ss]*FatDem[y] + locEV[i,y]*qEV[t] + Qscb[i,t] + Qfcb[i]      + Qgd[i,t] ;#- Qpv_hc[y,i,t,ss];						
	
subject to voltage_drop {y in Y, (i,j) in B, (t,ss) in SC }:
	V2[y,i,t,ss] - V2[y,j,t,ss] = 2*(P[y,i,j,t,ss]*R[i,j] + Q[y,i,j,t,ss]*X[i,j]) + I2[y,i,j,t,ss]*Z2[i,j];

subject to power_flow {y in Y, (i,j) in B, (t,ss) in SC }:
	V2[y,j,t,ss]*I2[y,i,j,t,ss] >= P[y,i,j,t,ss]^2 + Q[y,i,j,t,ss]^2; # NL
	
#subject to power_flow01 {y in Y, (i,j) in B, (t,ss) in SC }:
#	0.6*I2[y,i,j,t,ss] + V2[y,j,t,ss]*0 - 0.6*0 >= P[y,i,j,t,ss]^2 + Q[y,i,j,t,ss]^2; # NL
#	
#subject to power_flow02 {y in Y, (i,j) in B, (t,ss) in SC }:
#	1.2*I2[y,i,j,t,ss] + V2[y,j,t,ss]*1.2 - 1.2*1.2 >= P[y,i,j,t,ss]^2 + Q[y,i,j,t,ss]^2; # NL
#	
#subject to power_flow03 {y in Y, (i,j) in B, (t,ss) in SC }:
#	1.2*I2[y,i,j,t,ss] + V2[y,j,t,ss]*0 - 1.2*0 >= P[y,i,j,t,ss]^2 + Q[y,i,j,t,ss]^2; # NL
#	
#subject to power_flow04 {y in Y, (i,j) in B, (t,ss) in SC }:
#	0.6*I2[y,i,j,t,ss] + V2[y,j,t,ss]*1.2 - 0.6*1.2 >= P[y,i,j,t,ss]^2 + Q[y,i,j,t,ss]^2; # NL
	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Operational limits: considering excess and slack variables

#subject to operation01 {y in Y, i in N, (t,ss) in SC: Tb[i] == 1}:
#	QS[y,i,t,ss] - QSpen_folga[y,i,t,ss] <= PS[y,i,t,ss]*tan(acos(FPminInd));
#	
#subject to operation02 {y in Y, i in N, (t,ss) in SC: Tb[i] == 1}:
#	QS[y,i,t,ss] + QSpen_excesso[y,i,t,ss] >= -PS[y,i,t,ss]*tan(acos(FPminCap));
	
subject to operation03 {y in Y, i in N, (t,ss) in SC}:
	Vmin^2 <= V2[y,i,t,ss] <= Vmax^2;

subject to operation04 {y in Y, (i,j) in B, (t,ss) in SC}:
	I2[y,i,j,t,ss] <= Imax[i,j]^2;

subject to operation05 {y in Y, i in N, (t,ss) in SC: Tb[i] == 1}:
	PS[y,i,t,ss]^2 + QS[y,i,t,ss]^2 + PSn[y,i,t,ss]^2 <= SMAX[i]^2;				# NL 
	
#subject to operation03 {y in Y, i in N, (t,ss) in SC}:
#	Vmin^2 <= V2[y,i,t,ss] + V2pen_folga[y,i,t,ss] - V2pen_excesso[y,i,t,ss]  <= Vmax^2;
#
#subject to operation04 {y in Y, (i,j) in B, (t,ss) in SC}:
#	I2[y,i,j,t,ss] - I2pen[y,i,j,t,ss]  <= Imax[i,j]^2;
#
#subject to operation05 {y in Y, i in N, (t,ss) in SC: Tb[i] == 1}:
#	PS[y,i,t,ss]^2 + QS[y,i,t,ss]^2 + PSn[y,i,t,ss]^2 - S2pen[y,i,t,ss] <= SMAX[i]^2;				# NL 
	
	
	
#subject to operation06 {y in Y, i in N, (t,ss) in SC: Tb[i] == 1}:
#	PS[y,i,t,ss] + PSpen_excesso[y,i,t,ss] >= 0;				
		
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Fixed Capacitor Allocation
 
subject to FCB01_alocation {i in CB}:
	Qfcb[i] = Nfcb[i]*qcb;
	
subject to FCB02_alocation {i in CB}:
	0 <= Nfcb[i] <= NMC;
	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Voltage Regulator


		
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Switchable Capacitor Allocation

subject to SCB01_alocation {i in CB, t in PER}:
	Qscb[i,t] = Nscb[i,t]*qcb;
	
subject to SCB02_alocation {i in CB}:
	Nscb_max[i] <= NMC;

subject to SCB03_operation {i in CB, t in PER}:
	Nscb[i,t] <= Nscb_max[i];
	
#subject to SCB04_operation {i in CB, t in PER}:
#	Nscb_max[i] >= Nscb_ngbh[i,t];
	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  

										## Batterie Allocation: model from Norberto

subject to ESS01_alocation {i in BB}:
	Nsae[i] <= NMB;

subject to ESS02_alocation {i in BB, t in PER}:
	PsaeD[i,t] <= Nsae[i]*Psae_max;
	
subject to ESS03_alocation {i in BB, t in PER}:
	PsaeC[i,t] <= Nsae[i]*Psae_max;

subject to ESS01_operation {i in BB, t in PER:t>0}:
	Esae[i,t] = Esae[i,t-1] + Dt*(Sbase*eta_sae*PsaeC[i,t] - Sbase*PsaeD[i,t]/eta_sae - beta_sae*Esae[i,t]);
	
subject to ESS02_operation {i in BB}:
	Esae[i,0] = Esae[i,card(PER)-1] + Dt*(Sbase*eta_sae*PsaeC[i,0] - Sbase*PsaeD[i,0]/eta_sae - beta_sae*Esae[i,0]);

subject to ESS03_operation {i in BB, t in PER}:
	Esae_min*Nsae[i] <= Esae[i,t];
	
subject to ESS04_operation {i in BB, t in PER}:
	Esae[i,t] <= Esae_max*Nsae[i];
					
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  || 

										## Despachtable Generators Allocation

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

										## Hosting Capacity Constraints
	
subject to HC00 {i in PV}:
	Pper[i] <= Ppv_max;
	
subject to HC01 {i in PV}:
	Spv[i] = 1.1 * Pper[i];

subject to HC02 {i in PV, (t,ss) in SC}:
	Phc[i,t,ss] = Pper[i]*fatGer[t,ss] - Pcurt[i,t,ss];
	
subject to HC03 {i in PV, (t,ss) in SC}:
	Pcurt[i,t,ss] <= Pper[i]*fatGer[t,ss];
	
subject to HC04 {i in PV}:
	sum{(t,ss) in SC}Pcurt[i,t,ss] <= maxCurt*sum{(t,ss) in SC} (Pper[i]*fatGer[t,ss]);
	
#subject to HC05:
#	Sbase*sum{i in PV}Pper[i]*1e-3 <= 3;

										## PV operation - Volt-Var Control
										
#subject to PV02_operacao {i in PV,(t,s) in SC}:
#  sum{r in QR} a_q[r,i,t,s] = 1;
#
#subject to PV03_operacao {r in QR, i in PV,(t,s) in SC}:
#  theta_q[r,i,t,s] <= a_q[r,i,t,s];
#
#subject to PV04_operacao {i in PV,(t,s) in SC}:
#  Phc[i,t,s] = sum{r in 0..tr_q-1} (Pper_aq[r,i,t,s] * P_ext[r] + Pper_thetaq[r,i,t,s] * (P_ext[r+1] - P_ext[r]));
#
#subject to PV05_operacao {i in PV,(t,s) in SC}:
#  Qdisp[i,t,s] = sum{r in 0..tr_q-1} (1.1 * Pper_aq[r,i,t,s] * uq_ext[r] + 1.1 * Pper_thetaq[r,i,t,s] *(uq_ext[r+1] - uq_ext[r]));
#	
#	
#subject to PV06_0_operacao {y in Y, i in PV, (t,s) in SC}:
#    -Qdisp[i,t,s] <= Qpv_in[y,i,t,s];
#	
#subject to PV06_1_operacao {y in Y, i in PV, (t,s) in SC}:
#    Qpv_in[y,i,t,s] <= Qdisp[i,t,s];
#
#subject to PV07_operacao {y in Y, i in PV,(t,s) in SC}:
#  sum{r in VR} a_v[r,y,i,t,s] = 1;
#
#subject to PV08_operacao {r in VR,y in Y, i in PV,(t,s) in SC}:
#  theta_v[r,y,i,t,s] <= a_v[r,y,i,t,s];
#
#subject to PV09_operacao {y in Y, i in PV,(t,s) in SC}:
#  V2[y,i,t,s] = sum{r in 0..tr_v-1} (a_v[r,y,i,t,s] * Vp_ext[r] + theta_v[r,y,i,t,s] * (Vp_ext[r+1] - Vp_ext[r]));
#
#subject to PV10_operacao {y in Y, i in PV,(t,s) in SC}:
#  Qpv_in[y,i,t,s] = sum{r in 0..tr_v-1} (Qdisp1[r,y,i,t,s] * Qp_ext[r] + Qdisp2[r,y,i,t,s] *(Qp_ext[r+1] - Qp_ext[r]));
#	
#	
#	
#subject to PV11_operacao {r in VR, y in Y, i in PV,(t,s) in SC: r < tr_v}:
#  Qdisp1[r,y,i,t,s] >= Qdisp[i,t,s] + 0.44*Spv_av[r,y,i,t,s] - 0.44*Spv[i];
#  
#subject to PV12_operacao {r in VR, y in Y, i in PV,(t,s) in SC: r < tr_v}:
#  Qdisp1[r,y,i,t,s] <= 0.44*Spv_av[r,y,i,t,s];
#  
#subject to PV13_operacao {r in VR, y in Y, i in PV,(t,s) in SC: r < tr_v}:
#  Qdisp1[r,y,i,t,s] <= Qdisp[i,t,s];
#  
#subject to PV14_operacao {r in VR, y in Y, i in PV,(t,s) in SC: r < tr_v}:
#  Qdisp2[r,y,i,t,s] >= Qdisp[i,t,s] + 0.44*Spv_thetav[r,y,i,t,s] - 0.44*Spv[i];
#  
#subject to PV15_operacao {r in VR, y in Y, i in PV,(t,s) in SC: r < tr_v}:
#  Qdisp2[r,y,i,t,s] <= 0.44*Spv_thetav[r,y,i,t,s];
#  
#subject to PV16_operacao {r in VR, y in Y, i in PV,(t,s) in SC: r < tr_v}:
#  Qdisp2[r,y,i,t,s] <= Qdisp[i,t,s];
#  
#
#subject to PV17_operacao {r in QR, i in PV,(t,s) in SC: r < tr_q}:
#  Pper_aq[r,i,t,s] >= Pper[i] + Ppv_max*a_q[r,i,t,s] - Ppv_max;
#  
#subject to PV18_operacao {r in QR, i in PV,(t,s) in SC: r < tr_q}:
#  Pper_aq[r,i,t,s] <= Ppv_max*a_q[r,i,t,s];
#  
#subject to PV19_operacao {r in QR, i in PV,(t,s) in SC: r < tr_q}:
#  Pper_aq[r,i,t,s] <= Pper[i];
#  
#subject to PV20_operacao {r in QR, i in PV,(t,s) in SC: r < tr_q}:
#  Pper_thetaq[r,i,t,s] >= Pper[i] + Ppv_max*theta_q[r,i,t,s] - Ppv_max;
#  
#subject to PV21_operacao {r in QR, i in PV,(t,s) in SC: r < tr_q}:
#  Pper_thetaq[r,i,t,s] <= Ppv_max*theta_q[r,i,t,s];
#  
#subject to PV22_operacao {r in QR, i in PV,(t,s) in SC: r < tr_q}:
#  Pper_thetaq[r,i,t,s] <= Pper[i];
#  
#  
#subject to PV23_operacao {r in VR, y in Y, i in PV,(t,s) in SC: r < tr_v}:
#  Spv_av[r,y,i,t,s] >= Spv[i] + 1.1*Ppv_max*a_v[r,y,i,t,s] - 1.1*Ppv_max;
#  
#subject to PV24_operacao {r in VR, y in Y, i in PV,(t,s) in SC: r < tr_v}:
#  Spv_av[r,y,i,t,s] <= 1.1*Ppv_max*a_v[r,y,i,t,s];
#  
#subject to PV25_operacao {r in VR, y in Y, i in PV,(t,s) in SC: r < tr_v}:
#  Spv_av[r,y,i,t,s] <= Spv[i];
#  
#subject to PV26_operacao {r in VR, y in Y, i in PV,(t,s) in SC: r < tr_v}:
#  Spv_thetav[r,y,i,t,s] >= Spv[i] + Ppv_max*theta_v[r,y,i,t,s] - 1.1*Ppv_max;
#  
#subject to PV27_operacao {r in VR, y in Y, i in PV,(t,s) in SC: r < tr_v}:
#  Spv_thetav[r,y,i,t,s] <= 1.1*Ppv_max*theta_v[r,y,i,t,s];
#  
#subject to PV28_operacao {r in VR, y in Y, i in PV,(t,s) in SC: r < tr_v}:
#  Spv_thetav[r,y,i,t,s] <= Spv[i];
  	

# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  || 
	
# =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  ||  =========  || 

										## Volt Var Control for PVs

##subject to PV01_operacao {y in Y,i in PV, (t,ss) in SC}:
##	Qpv_in[y,i,t,ss] = Qdisp[i,t,ss]*Npv_in[y,i,t,ss];

subject to PV02_operacao {y in Y,i in PV, (t,ss) in SC}:
	Qpv_ngbh[y,i,t,ss] - k_pv_hc[y,i,t,ss] <= Qpv_hc[y,i,t,ss] <= Qpv_ngbh[y,i,t,ss] + k_pv_hc[y,i,t,ss];
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
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

	










