# download all StrainSEEK V2 vcf files with chemotype data

load("../kannapedia.Rda")

v2_vcfs <- records[records$acf.ss_version %in% "V2" & 
                  (records$acf.thc_thca != "" | records$acf.cbd_cbda != "") &
                   records$acf.myrcene != "" &
                   records$acf.vcf_url != "",]

for (row in 1:nrow(v2_vcfs)) {
  tryCatch(download.file(v2_vcfs$acf.vcf_url[row], destfile = basename(v2_vcfs$acf.vcf_url[row]), method="libcurl"), 
           error = function(e) print(paste(v2_vcfs$acf.vcf_url[row], "couldn't be downloaded")))    
}

