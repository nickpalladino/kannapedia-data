# Kannapedia Genomic Selection Project

The goal of this project is a learning excercise to see if data available on kannapedia can be used to perform genomic selection for the captured chemotypes with any sort of accuracy.

## Dataset

Kannapedia contains 712 cannabis genotypes performed with StrainSEEK V1 or StrainSEEK V2 from medicinal genomics. 

StrainSEEK V1: 352

StrainSEEK V2: 360

### Genotypes

StrainSEEK V2 has 25,000-50,000 SNPs across the genome with increased density on chemotype associated genes. SNPs with higher information content in StrainSEEK V1 were carried over into StrainSEEK V2 for backwards compatibility [[1]](https://www.medicinalgenomics.com/new-data-visualizations-kannapedia/). StrainSEEK V1 SNPs were mapped against the canSat3 reference genome whereas StrainSEEK V2 SNPs were mapped against the Jamaican Lion reference genome. 

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
