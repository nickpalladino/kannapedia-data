library(vcfR)
library(ggplot2)

fix_df <- as.data.frame(getFIX(read.vcfR('RSP11176_blockchain.vcf')))

snps <- fix_df[fix_df$FILTER %in% "PASS" &
               fix_df$REF %in% c("A","C","G","T") & 
              (fix_df$ALT == "T,<NON_REF>" |
               fix_df$ALT == "C,<NON_REF>" |
               fix_df$ALT == "A,<NON_REF>" |
               fix_df$ALT == "G,<NON_REF>"), ]

snps$POS <- as.numeric(snps$POS)

ggplot(aes(x=POS), data=snps) +
  geom_histogram(binwidth=1000) +
  xlab("Position") +
  ylab("Number of SNPs") +
  ggtitle("SNP Distribution 1000 bp Window")
