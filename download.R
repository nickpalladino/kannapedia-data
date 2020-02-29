# download kannapedia metadata

library(httr)
library(jsonlite)

# run this to get initial data or to update from kannapedia
download <- function() {
  
  # wordpress REST api, 100 records per page is the max
  url <- "https://www.kannapedia.net/wp-json/wp/v2/strains?_fields=acf&per_page=100"
  
  # get first page and info for pagination
  response <- GET(url)
  headers <- headers(response)
  total_records <- headers[["x-wp-total"]]
  num_pages <- headers[["x-wp-totalpages"]]
  records <- fromJSON(content(response,"text"), simplifyDataFrame = TRUE, flatten = TRUE)
  
  # get all other pages of data and append to data frame
  for(i in 2:num_pages) {
    response <- GET(paste0(url,"&page=",i))
    content_page <- fromJSON(content(response,"text"), simplifyDataFrame = TRUE, flatten = TRUE)
    records <- rbind(records, content_page)
  }
  
  save(records,file="kannapedia.Rda")
}

# download() 
load("kannapedia.Rda")

# only want StrainSEEK V2 records with vcf files and cannabinoid chemotypes

v2 <- records[records$acf.ss_version == "V2",]
v2_vcf <- v2[!is.na(v2$acf.vcf_url),]
v2_vcf_thc_cbd <- v2_vcf[v2_vcf$acf.thc_thca != "",]

thc_cbd <- records[records$acf.thc_thca != "",]
