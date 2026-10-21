# ---------------------------- NEIGHBORHOOD 3 OF VND -------------------------------- #

subject to neighborhood_VND3_FCB01 {i in CB}:
	Nfcb_ngbh[i] - k_fcb <= Nfcb[i] <= Nfcb_ngbh[i] + k_fcb;
					
subject to neighborhood_VND3_SCB01 {i in CB}:
	Nscb_max_ngbh[i] - k_scb <= Nscb_max[i] <= Nscb_max_ngbh[i] + k_scb;
	
subject to neighborhood_VND3_SCB02 {i in CB, t in PER}:
	1>0;#Nscb_ngbh[i,t] - k_scb <= Nscb[i,t] <= Nscb_ngbh[i,t] + k_scb;
	
subject to neighborhood_VND3_BB01 {i in BB}:
	Nsae_ngbh[i] - k_sae <= Nsae[i] <= Nsae_ngbh[i] + k_sae;
	
#subject to neighborhood_VND3_PV01 {i in PVds}:
#	Npv_ngbh[i] - k_pv <= Npv[i] <= Npv_ngbh[i] + k_pv;
#	
subject to neighborhood_VND3_GD01 {i in GD}:
	Ngd_ngbh[i] - k_gd <= Ngd[i] <= Ngd_ngbh[i] + k_gd;
	
# ----------------------------------------------------------------------------------- #