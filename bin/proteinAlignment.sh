#! bin/bash
# El primer paso para modelar es ahcer un alineamiento multiple.
# Podemos hacer alineamientos basados en matrices de distancia (clustal),
# o basados en modelos ocultos de Markov (HMMER).

# Unir fasta
cat ../data/*.fa > ../results/P11018_templates.fa

# Clustal
clustalw ../results/P11018_templates.fa

# El alineamiento por secuencia tiene algunos inconvenientes que podrian ser
# problematicos al momento de modelar.

# Un modelo ocult de markov es un modelo probabilistico que parte de un alineamiento
# base para construir un alineamiento multiple 
# Nuestro modelo base sera un alinemiento estructural usando STAMP

# STAMP
# Hacer directorio con los pdbs
../mkdir  STAMP
# Liga simbolica a los pdbs
ln -s ../data/*.pdb ../STAMP
# Creamos el archivo templates.domains
ls ../STAMP > ../STAMP/templates.domains
 
# Editamos el templates.domains para ajustar al formato
# <ruta> <id> <{ ALL }>

# Corremos STAMP
stamp -l ../STAMP/templates.domains -rough -n 2 -prefix templates > templates.out

# Movemos los archivos 
mv templates.* ../results/
mv stamp_rough.trans ../results/

# Transformamos para visualizar
transform -f ../results/templates.4 -g -o ../results/templates_stamp.pdb 

# Visualizar 
rasmol ../templates_stamp.pdb

# Convertimos el formato del alineamiento de bloc a clustal
aconvertMod2.pl -in b -out c <../results/templates.4> ../results/templates_stamp.aln

# Delete space and ?
grep -v "^space" ../results/templates_stamp.aln | grep -v "?" > ../results/templates_stamp_cleaned.aln

# Este archivo es nuestro alineamiento base para construir el alineamiento
# usando modelos ocultos de markov

# Modelo oculto de markov
conda activate hmmer-2.2g
# create the HMM
hmmbuild ../results/templates.hmm ../results/templates_stamp_cleaned.aln 
hmmcalibrate ../results/templates.hmm

# Hacer el alineamiento usando el modelo oculto da Markov
hmmalign -o ../results/P11018_templates_hmm.sto ../results/templates.hmm ../results/P11018_templates.fa

# Visualisamos en terminal

## Repetimos el procedimiento usando los PDBs obtenidos de SCOP 
## Obtuvimos un archivo P11018_templates_scop.sto 
## Haremos el modelado 3D

# Modificamos el archivo *.py  para poner la ruta al archivo de alineamiento en
# formato clustal  y poner en knowns las proteinas template
mod9.21 scop_modeling.py

## Evaluacion

# Usamos programs web para evaluar el perfil estereoquimico y energetico

# Usamos DSSP y PSIPRED para evaluar la resolucion de inserciones y dominios
# Movemos los archivos a un directorio DSSP

# Solve errors
# 
