#!/bin/bash
#----------------------------------------------------------------------------------------------------------------------#
#NAME 
#	langstat.sh - affiche le nombre d'occurrence de chaque lettre de l'alphabet au sein d'un fichier dictionnaire

#SYNOPSIS  
# 	langstat.sh [FILE] [OPTION]

#DESCRIPTION
#	Le fichier dictionnaire à indiquer en paramètre doit n'avoir qu'un mot par ligne (ignore la casse)

#OPTIONS
#	-p, --pourcentage
#		Indique le pourcentage de mots utilisant chaque lettre au sein du dictionnaire

#AUTHOR
#	ChinaskiJr - January 2018
#----------------------------------------------------------------------------------------------------------------------#

#Trie par ordre décroissant et retourne les lignes contenues dans $sortie  
affichageDecroissant () {
	sort -nro $sortie $sortie 
	cat $sortie
}

#extrait le nombre de mots utilisant chaque lettre de l'alphabet de A à Z
recherche () {
	for i in "${alphabet[@]}" 
	do
		echo "$(grep -ci $i $dictionnaire) - $i"  >> $sortie
	done
}


#Rajoute le pourcentage de mots utilisant chaque lettre de l'alphabet par rapport au nombre de mot total
recherchePourcentage () {
	for i in "${alphabet[@]}"
	do	
		echo -n `grep -ci $i $dictionnaire` - $i >> $sortie  
		#(nombre de mots utilisant la lettre * 100)/nombre de mot total)
		result=$(echo "scale=2;(`grep -ci $i $dictionnaire` * 100) / `wc -l < $dictionnaire`" | bc) 
		echo " : $result %" >> $sortie
	done
}


#Vérification du paramètre dictionnaire et initialisation de la  variable
if [ -z $1 ] || [ ! -e $1 ]
then
	echo "Le paramètre doit être un dictionnaire valide"
	exit 1
else
	dictionnaire="$1"
fi


#Initialisation du fichier temporaire
echo '' > "/tmp/temp" #Écrasement du fichier temporaire s'il existait déjà
sortie="/tmp/temp"


#Création d'un tableau comprenant les 26 lettres de l'alphabet
alphabet=('A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z')


#Recherche des lettres (programme principal) 
#Si la fonction détecte plus d'un paramètre...
if [ $# -ge 2 ]
then
	while true
	do
		case "$2" in
			#... si on saisit l'option -p ...
			-p | --pourcentage)
			#... alors on utilise la fonction "recherchePourcentage"
				recherchePourcentage
				affichageDecroissant
				break
				;;
			#... si le paramètre est inconnu, message d'erreur et on renvoie le code 1 
			*)
				echo "Paramètre non reconnu"
				exit 1
				;;
		esac
	done
#Si la fonction n'a qu'un seul paramètre, il s'agit donc du dictionnaire (on l'a vérifié au préalable : ll. 49-55)...
else 
#...on utilise la fonction recherche 
recherche
affichageDecroissant
fi

rm $sortie

exit 0


