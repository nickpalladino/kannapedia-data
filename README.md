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

If it turns out that the StrainSEEK data is useful from predicting chemotype GEBV with good accuracy, there are issues with using it in a breeding program to overcome. [It currently costs $569.05 for one sample and takes 6 weeks to process](http://store.medicinalgenomics.com/home/Strain-Identification-and-Registration/StrainSEEK-cannabis-and-hemp-strain-identification-3-megabases.html). These are not viable options for cost or time. [A SNP chip](https://www.medicinalgenomics.com/eurofins-scientific-medicinal-genomics-partner-on-worlds-most-comprehensive-informative-cannabis-snp-chip/) has been announced for release this year that will contain SNPs from StrainSEEK. This should result in a significant cost and time reduction that could make it's use viable in a breeding program. It remains to be seen  which of the SNPs from StrainSEEK will be present on the SNP chip.

#### Data Format

A GVCF file of variants against the reference genome is included as well as a fastq files of the raw sequencing data. The Jamaican Lion reference genome is made up of 387 contigs. [Chromosomes have not yet been called due to them being very similar in size and deletions could result in the wrong call](https://www.youtube.com/watch?v=uTgvw_O-g84). The GVCF calls are therefore positioned with respect to the contigs. The GVCF files were generated with the Illumina DRAGEN tool. The block below shows the commandline parameters used to generate one of the GVCF files:

> DRAGENCommandLine=<ID=dragen,Version="SW: 05.011.281.3.2.5, HW: 05.011.281",Date="Fri May 10 16:02:3
6 UTC 2019",CommandLineOptions="-r /ephemeral/JLion_V6_7M_polarstar_purged/ --output-directory /Dragen
/SS2/Dragen_calls --output-file-prefix RSP10105 -1 s3://mgcdata/SS2/runs/COMBD_RSP10105/RSP10105_COMBD
_20180517_R1_001.fastq.gz -2 s3://mgcdata/SS2/runs/COMBD_RSP10105/RSP10105_COMBD_20180517_R2_001.fastq
.gz --intermediate-results-dir /ephemeral/tmp --enable-variant-caller true --vc-sample-name RSP10105 -
-vc-emit-ref-confidence GVCF --enable-duplicate-marking true --enable-map-align-output true --RGSM RSP
10105 --RGID RSP10105">

As shown in the image below, GVCF files are an intermediate format. These represent the variant calls. From these files, you then can do a joint-call genotyping to generate the SNPs.

![GCVF Workflow](https://us.v-cdn.net/5019796/uploads/editor/1l/5bzcah5uaksr.png)

DRAGEN runs on special hardware utilizing FPGAs which limits it's availability being primarily available through Illumina BaseSpace. Although faster, it is proprietary and more difficult to access compared to open source general purpose implementations like GATK. [There is an effort called DRAGEN-GATK to allow samples analyzed in either pipeline to be combined without worrying about batch effects](https://gatk.broadinstitute.org/hc/en-us/articles/360039984151-DRAGEN-GATK-Update-Let-s-get-more-specific). Since all of the GVCFs are generated with DRAGEN, as long as GATK doesn't have issues with the output, it should be possible to use [GATK GenotypeGVCFs](https://gatk.broadinstitute.org/hc/en-us/articles/360035889971--How-to-Consolidate-GVCFs-for-joint-calling-with-GenotypeGVCFs) to generate a VCF from the GVCFs. Otherwise, all of the samples would have to be reprocessed from the raw sequencing data in GATK.

First, the GVCF files need to be consolidated into a single file. There are two options in GATK, either `GenomicsDBImport` or `CombineGVCFs`. `GenomicsDBImport` is recommended but I haven't figured out how to use the intrevals parameter yet so I went with `CombineGVCFs`. In order to run `CombineGVCFs`, the reference genome used in variant calling for the GVCFs is needed. The  reference fasta is available [here](https://genomevolution.org/coge/api/v1/genomes/55184/sequence). The file comes with a .faa extension that had to be renamed to .fasta to work with the GATK tools. Also, the contig names in the fasta file were named as `lcl|contig` whereas the GVCF file names were just`contig`. A new fasta file with renamed contigs was generated with the following command:

```
sed 's/lcl|contig/contig/g' Cannabis_sativa_Jamaican_Lion.fasta > Cannabis_renamed.fasta
```

Next index and dictionary files had to be generated for the reference sequence using the following commands: 

```
samtools faidx Cannabis_renamed.fasta

gatk CreateSequenceDictionary -R Cannabis_renamed.fasta
```
After this, the reference sequence is prepared for running `CombineGVCFs`. In this case, just two of the GVCF files are being combined.

```
gatk CombineGVCFs -R ../Cannabis_renamed.fasta --variant RSP10551_blockchain.vcf.gz --variant RSP10105_blockchain.vcf.gz -O combined.vcf.gz
```

After this, joint calling can be performed:

```
gatk GenotypeGVCFs -R ../Cannabis_renamed.fasta -V combined.vcf.gz -O test.vcf
```

The resulting vcf file will contain SNPs and INDELs for the samples.

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
