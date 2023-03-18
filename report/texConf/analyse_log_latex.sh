#!/bin/bash

# Ce script affiche les erreurs du log latex en cherchant le caractère '!'
# Initialisation de la variable qui contiendra le nom du dernier fichier .tex
last_file=""

# Boucle de lecture de l'entrée
while read line; do
#  Vérification si la ligne contient un nom de fichier .tex
  if [[ $line == *.tex ]]; then
      last_file=$line
      nom_fichier=${last_file##*/}
  fi
  
#  Si la ligne contient un point d'exclamation
  if [[ $line == *!* ]]; then
    echo "LaTex error in file :" $nom_fichier
    echo $line
    head -n 2
    exit "Press 'q' and enter if needed"
    exit -1
  fi

done

# Exemple d'utilisation : 
# cat fichier.txt | ./mon_script.sh

# Notes : 
# - On utilise la commande head pour limiter le nombre de lignes affichées à 2
# - On incrémente le compteur de lignes à la fin de chaque boucle pour prendre en compte toutes les lignes