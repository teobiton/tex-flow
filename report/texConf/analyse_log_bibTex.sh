#!/bin/bash

# This script keep only line with Warning


echo "Start BibTex compilation"

# Boucle de lecture de l'entrée
while read line; do

#  Vérification si la ligne contient Warning
  if [[ $line == Warning* ]]; then
      echo -e ' \t ' $line
  fi
  
done

# Exemple d'utilisation : 
# cat fichier.txt | ./mon_script.sh
