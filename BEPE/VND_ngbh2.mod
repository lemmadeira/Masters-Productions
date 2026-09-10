# ---------------------------- NEIGHBORHOOD 2 OF VND -------------------------------- #

subject to neighborhood_VND2_FCB01 {i in CB}:
	Nfcb_ngbh[i] - k_fcb <= Nfcb[i] <= Nfcb_ngbh[i];
	
subject to neighborhood_VND2_FCB02:
	sum{i in CB}(Nfcb_ngbh[i]) - delta_fcb <= sum{i in CB}(Nfcb[i]) <= sum{i in CB}(Nfcb_ngbh[i]);
	
subject to neighborhood_VND2_SCB01 {i in CB}:
	Nscb_max_ngbh[i] - k_scb <= Nscb_max[i] <= Nscb_max_ngbh[i];
	
subject to neighborhood_VND2_SCB02:
	sum{i in CB}(Nscb_max_ngbh[i]) - delta_scb <= sum{i in CB}(Nscb_max[i]) <= sum{i in CB}(Nscb_max_ngbh[i]);

subject to neighborhood_VND2_SCB03 {i in CB, t in PER}:
 	1>0;#Nscb_ngbh[i,t] - k_scb <= Nscb[i,t] <= Nscb_ngbh[i,t];
	
subject to neighborhood_VND2_SCB04 {t in PER}:
	sum{i in CB}(Nscb_ngbh[i,t]) - delta_scb <= sum{i in CB}(Nscb[i,t]) <= sum{i in CB}(Nscb_ngbh[i,t]);
	
subject to neighborhood_VND2_BB01 {i in BB}:
	Nsae_ngbh[i] - k_sae <= Nsae[i] <= Nsae_ngbh[i];
	
subject to neighborhood_VND2_BB02:
	sum{i in BB}(Nsae_ngbh[i]) - delta_sae <= sum{i in BB}(Nsae[i]) <= sum{i in BB}(Nsae_ngbh[i]);
	
#subject to neighborhood_VND2_PV01 {i in PVds}:
#	Npv_ngbh[i] - k_pv <= Npv[i] <= Npv_ngbh[i];
#	
#subject to neighborhood_VND2_PV02:
#	sum{i in PVds}(Npv_ngbh[i]) - delta_pv <= sum{i in PVds}(Npv[i]) <= sum{i in PVds}(Npv_ngbh[i]);
#	
subject to neighborhood_VND2_GD01 {i in GD}:
	Ngd_ngbh[i] - k_gd <= Ngd[i] <= Ngd_ngbh[i];
	
subject to neighborhood_VND2_GD02:
	sum{i in GD}(Ngd_ngbh[i]) - delta_gd <= sum{i in GD}(Ngd[i]) <= sum{i in GD}(Ngd_ngbh[i]);
	
# ----------------------------------------------------------------------------------- #