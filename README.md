# Kannapedia Genomic Selection Project

The goal of this project is a learning excercise to see if data available on kannapedia can be used to perform genomic selection for the captured chemotypes with any sort of accuracy.

## Dataset

Kannapedia contains 712 cannabis genotypes performed with StrainSEEK V1 or StrainSEEK V2 from medicinal genomics. 

StrainSEEK V1: 352

StrainSEEK V2: 360

### Genotypes

The [StrainSEEK V2](https://www.medicinalgenomics.com/strainseek-strain-identification-and-registration/) assay sequences more than 3.5 million bases (Mb) across thousands of high-value targets, including 29 cannabinoid and terpene synthase genes as well as several genes for seed production and sex determination. Also included in the assay are 30,000 SNP’s that can be used to create high-density SNP maps for marker-assisted breeding. StrainSEEK V2 uses a [targeted enrichment](https://www.kannapedia.net/cannabis-phylotree/) approach to sequence the target areas of the genome. SNPs with higher information content in StrainSEEK V1 were carried over into StrainSEEK V2 for [backwards compatibility](https://www.medicinalgenomics.com/new-data-visualizations-kannapedia/). StrainSEEK V1 SNPs were mapped against the canSat3 reference genome whereas StrainSEEK V2 SNPs were mapped against the Jamaican Lion reference genome.

The image below shows the number of SNPs and indels across 40 genomes mapped to the Jamaican Lion reference genome. [The most genetically distant hemp sample averaged 17 million SNPs whereas closer relatives averaged 12.8 million SNPs](https://www.biorxiv.org/content/10.1101/2020.01.03.894428v1.full).
![Cannabis SNPs](https://www.biorxiv.org/content/biorxiv/early/2020/01/05/2020.01.03.894428/F5.large.jpg?width=800&height=600&carousel=1)

The density of SNPs across the genome in StrainSEEK V2 needs to be considered. It has a subset of cannabis SNPs and it is unclear if there is even spacing across the genome even if more sparse. Linkage disequilibrium also needs to be considered. Machine learning methods have been [successfully used](https://www.frontiersin.org/articles/10.3389/fgene.2018.00237/full) for selecting subsets of SNPs from a whole SNP panel for predicting GEBV. This could be a viable option especially since we'd be predicting cannabinoid and terpene traits that have known coverage in the assay.

### Phenotypes

A subset of the samples in Kannnapedia contain the following chemotype data:
* cannabinoids
* terpenes

### Factors Affecting Genomic Selection

#### Trait Heritability

Cannabinoid inheritance first proposed [one locus, two alleles](https://www.genetics.org/content/163/1/335), recently [multiple loci](https://nph.onlinelibrary.wiley.com/doi/full/10.1111/nph.13562#nph13562-fig-0001)

#### Training Population Size

Only 45 samples in the dataset using StrainSEEK V2 that have cannabinoid data and a linked vcf file. If including StrainSEEK V1 and StrainSEEK V2 vcf file, then there are 204 samples. The SNPs would have to be limited to what is available in StrainSEEK V1.

#### Training Population Representative
Selections shoud be closely related to training population.

#### SNP Density
* Linkage disequilibrium

### Other Datasets

* Phylos
* Lynch
* Sawler

## Genomic Selection

### Methods

* RR-BLUP - assume normal distribution of SNP effects
* BayesA - assume prior distribution of effects 
* BayesB - assume some SNP effects are zero
* Nonparametric - machine learning random forest / neural net

### GEBV Accuracy 

[training population size, narrow-sense heritability, independent loci affecting trait](https://link.springer.com/article/10.1007/s00122-018-3270-8)

[Analytical method](https://sci-hub.tw/https://www.nature.com/articles/nrg2575) for predicting the accuracy of genomic selection assuming that all SNPs have an effect and these effects are normally distributed. If the SNP effects are not normally distributed, with some large effects and many SNPs with no effect, the size of the population required will be smaller.


![GEBV Accuracy Plot](images/gebv_accuracy.jpg?raw=true "GEBV Accuracy")
