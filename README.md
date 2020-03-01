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

#### SNP Density
* Linkage disequilibrium

### Other Datasets

* Phylos
* Lynch
* Sawler

