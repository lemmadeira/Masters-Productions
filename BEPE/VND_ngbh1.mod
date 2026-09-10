# ---------------------------- NEIGHBORHOOD 1 OF VND -------------------------------- #

subject to neighborhood_VND1_FCB01 {i in CB}:
	Nfcb_ngbh[i] <= Nfcb[i] <= Nfcb_ngbh[i] + k_fcb;
	
subject to neighborhood_VND1_FCB02:
	sum{i in CB}(Nfcb_ngbh[i]) <= sum{i in CB}(Nfcb[i]) <= delta_fcb + sum{i in CB}(Nfcb_ngbh[i]);
	
subject to neighborhood_VND1_SCB01 {i in CB}:
	Nscb_max_ngbh[i] <= Nscb_max[i] <= Nscb_max_ngbh[i] + k_scb;
	
subject to neighborhood_VND1_SCB02:
	sum{i in CB}(Nscb_max_ngbh[i]) <= sum{i in CB}(Nscb_max[i]) <= delta_scb + sum{i in CB}(Nscb_max_ngbh[i]);
	
subject to neighborhood_VND1_SCB03 {i in CB, t in PER}:
	1>0;#Nscb_ngbh[i,t] <= Nscb[i,t] <= Nscb_ngbh[i,t] + k_scb;
	
subject to neighborhood_VND1_SCB04 {t in PER}:
	sum{i in CB}(Nscb_ngbh[i,t]) <= sum{i in CB}(Nscb[i,t]) <= delta_scb + sum{i in CB}(Nscb_ngbh[i,t]);
	
subject to neighborhood_VND1_BB01 {i in BB}:
	Nsae_ngbh[i] <= Nsae[i] <= Nsae_ngbh[i] + k_sae;
	
subject to neighborhood_VND1_BB02:
	sum{i in BB}(Nsae_ngbh[i]) <= sum{i in BB}(Nsae[i]) <= delta_sae + sum{i in BB}(Nsae_ngbh[i]);
	
#subject to neighborhood_VND1_PV01 {i in PVds}:
#	Npv_ngbh[i] <= Npv[i] <= Npv_ngbh[i] + k_pv;
#	
#subject to neighborhood_VND1_PV02:
#	sum{i in PVds}(Npv_ngbh[i]) <= sum{i in PVds}(Npv[i]) <= delta_pv + sum{i in PVds}(Npv_ngbh[i]);
#	
subject to neighborhood_VND1_GD01 {i in GD}:
	Ngd_ngbh[i] <= Ngd[i] <= Ngd_ngbh[i] + k_gd;
	
subject to neighborhood_VND1_GD02:
	sum{i in GD}(Ngd_ngbh[i]) <= sum{i in GD}(Ngd[i]) <= delta_gd + sum{i in GD}(Ngd_ngbh[i]);
	
# ----------------------------------------------------------------------------------- #