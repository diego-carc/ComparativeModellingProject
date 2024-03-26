#! bin/bash

# Sequence based alignment

## Concatenate fasta
cat ../data/*.fa > ../results/P11018_templates.fa

## Multiple alignment using clustal
clustalw ../results/P11018_templates.fa

# Structural alignment

## First we manually create the template.domains file

## Run STAMP
stamp -l ../data/templates.domains -rough -n 2 -prefix ../results/templates_stamp > ../results/templates_stamp.out

## Move file
mv stamp_rough.trans ../results/

## Convert bloc alignment to clustal format
aconvertMod2.pl -in b -out c <../results/templates_stamp.4> ../results/templates_stamp.aln
grep -v "^space" ../results/templates_stamp.aln | grep -v "?" > temp && mv temp ../results/templates_stamp.aln


# Building HMM

## Create HMM
conda activate hmmer-2.2g
hmmbuild ../results/templates.hmm ../results/templates_stamp.aln 
hmmcalibrate ../results/templates.hmm

## Align using HMM
hmmalign -o ../results/P11018_templates_hmm.sto ../results/templates.hmm ../results/P11018_templates.fa

# Strcutural modeling

## We modified the struct_modelling.py file to use the structural alignment
## Transform alignment to pir formart 
aconvertMod2.pl -in c -out p <../results/P11018_templates.aln> ../SequenceModelling/P11018_templates.pir
aconvertMod2.pl -in h -out p <../results/P11018_templates_hmm.sto> ../StructuralModelling/P11018_templates_hmm.pir

## Run modeller
### From StructuralModelling
mod9.21 struct_modeling.py
### From SequenceModelling
mod9.21 seq_modelling.py

## Evaluacion

# Usamos programs web para evaluar el perfil estereoquimico y energetico

# Usamos DSSP y PSIPRED para evaluar la resolucion de inserciones y dominios
# Movemos los archivos a un directorio DSSP

# Solve errors

