suppressMessages({
 library("sleuth")
})

# set input and output dirs
datapath <- "/work/gene8940/sec84829/project/kallisto"
resultdir <- "/work/gene8940/sec84829/project"
setwd(resultdir)

# create a sample-to-condition metadata object
sample_id <- dir(file.path(datapath))
kallisto_dirs <- file.path(datapath, sample_id)
sample <- c("SRX7822256", "SRX7822257", "SRX7822258", "SRX7822259","SRX7822260","SRX7822261","SRX7822262","SRX7822263","SRX7822264")
condition <- c("Control", "Control", "Control", "Pd-dppf-mpo","Pd-dppf-mpo","Pd-dppf-mpo","Pt-dppf-mpo","Pt-dppf-mpo","Pt-dppf-mpo")
samples_to_conditions <- data.frame(sample,condition)
samples_to_conditions <- dplyr::mutate(samples_to_conditions, path = kallisto_dirs)

# check that directories and metadata object are OK
print(kallisto_dirs)
print(samples_to_conditions)

# read data into sleuth_object, make it so you can read in tpms as well
sleuth_object <- sleuth_prep(samples_to_conditions, extra_bootstrap_summary=TRUE, read_bootstrap_tpm=TRUE)

# estimate parameters for the full linear model that includes the conditions as factors
sleuth_object <- sleuth_fit(sleuth_object, ~condition, 'full')

# estimate parameters for the reduced linear model that assumes equal transcript abundances in both conditions
sleuth_object <- sleuth_fit(sleuth_object, ~1, 'reduced')

# perform likelihood ratio test to identify transcripts whose fit is significantly better under full model relative to reduced model
sleuth_object <- sleuth_lrt(sleuth_object, 'reduced', 'full')

# check that sleuth object is OK
models(sleuth_object)

# Coding control test summarize the sleuth results and visualize results for the twenty most significant transcripts
sleuth_table <- sleuth_results(sleuth_object, 'reduced:full', 'lrt', show_all = FALSE)
sleuth_significant <- dplyr::filter(sleuth_table, qval <= 0.05)

pdf(file="ProjectSleuthControlResults.pdf")
for(i in sleuth_significant$target_id[1:10]) {
  p1 <- plot_bootstrap(sleuth_object, i, units = "tpm", color_by = "condition")
  print(p1)
}

dev.off()


#
#
#
# Wald test for differential expression for twenty best Pd-dppf-mpo differentiated genes

# read data into sleuth_object, make it so you can read in tpms as well
sleuth_object1 <- sleuth_prep(samples_to_conditions, extra_bootstrap_summary = TRUE, read_bootstrap_tpm=TRUE)

# estimate parameters for the full linear model that includes the conditions as factors
sleuth_object1 <- sleuth_fit(sleuth_object1, ~condition, 'full')

# estimate parameters for the reduced linear model that assumes equal transcript abundances in both conditions
sleuth_object1 <- sleuth_fit(sleuth_object1, ~1, 'reduced')

Pd <- sleuth_wt(sleuth_object1, 'conditionPd-dppf-mpo', 'full')
Sleuth_results_Pd <- sleuth_results(Pd, test = 'conditionPd-dppf-mpo', show_all = FALSE)
sleuth_significant_Pd <- dplyr::filter(Sleuth_results_Pd, qval <= 0.05)

pdf(file="Pd-dppf-mpo_Results.pdf")
for(i in sleuth_significant_Pd$target_id[1:10]) {
  p2 <- plot_bootstrap(sleuth_object1, i, units = "tpm", color_by = "condition")
  print(p2)
}

dev.off()


#
#
#
#
# Summarize and visual genes of interest (TcCLB.509461.90,TcCLB.511903.250,TcCLB.507609.60,TcCLB.511655.50,TcCLB.507019.80)

pdf(file="TcCLB.509461.90mRNA.pdf")
p4 <- plot_bootstrap(Pd, target_id = 'TcCLB.509461.90:mRNA', units = "tpm", color_by = "condition")
print(p4)
dev.off()


pdf(file="TcCLB.511903.250mRNA.pdf")
p5 <- plot_bootstrap(Pd, target_id = 'TcCLB.511903.250:mRNA', units = "tpm", color_by = "condition")
print(p5)
dev.off()


pdf(file="TcCLB.507609.60mRNA.pdf")
p6 <- plot_bootstrap(Pd, target_id = 'TcCLB.507609.60:mRNA', units = "tpm", color_by = "condition")
print(p6)
dev.off()


#
#
# Wald test for differential expression for twenty best Pt-dppf-mpo differentiated genes

# read data into sleuth_object, make it so you can read in tpms as well
sleuth_object2 <- sleuth_prep(samples_to_conditions, extra_bootstrap_summary = TRUE, read_bootstrap_tpm=TRUE)

# estimate parameters for the full linear model that includes the conditions as factors
sleuth_object2 <- sleuth_fit(sleuth_object2, ~condition, 'full')

# estimate parameters for the reduced linear model that assumes equal transcript abundances in both conditions
sleuth_object2 <- sleuth_fit(sleuth_object2, ~1, 'reduced')

Pt <- sleuth_wt(sleuth_object1, 'conditionPt-dppf-mpo', 'full')
Sleuth_results_Pt <- sleuth_results(Pt, test = 'conditionPt-dppf-mpo', show_all = FALSE)
sleuth_significant_Pt <- dplyr::filter(Sleuth_results_Pt, qval <= 0.05)

pdf(file="Pt-dppf-mpo_Results.pdf")
for(i in sleuth_significant_Pt$target_id[1:10]) {
  p3 <- plot_bootstrap(sleuth_object2, i, units = "tpm", color_by = "condition")
  print(p3)
}

dev.off()



#Quit R
quit(save="no")
