#!/bin/bash


description="Tour + Clavier/Souris"
prix_vente=80

fiche_vente=~/.fiche_vente.txt
utilisation_fiche=0
message_validation="Veuillez saisir la configuration de votre ordinateur à vendre"
message_fiche="Cette fiche de vente a déjà été renseignée, voulez-vous l'utiliser ?"

message_erreur_saisie="
<span color=\"red\">Description ou prix incorrect !</span>

Veuillez ressaisir la fiche" 


clear

export SUDO_ASKPASS=/usr/bin/gksudo

[ ! "${SUDO_USER}" ] && { cd "$(dirname "$0")"; exec gksu -S -- "./${0##*/}"; }

if test -f $fiche_vente 
then

	source ${fiche_vente}

	message_fiche_complet="
	${message_fiche} 

	<span color=\"blue\">Description</span> : ${description}
	<span color=\"blue\">Prix de vente</span> : ${prix_vente} €

	"

	zenity --question --no-wrap --width=700 --text="$message_fiche_complet"

	utilisation_fiche=$?

	echo "utilisation_fiche = $utilisation_fiche"

fi			


if ! test -f ${fiche_vente} || [[ ${utilisation_fiche} == 1 ]]
then


	description=$(zenity --list \
				   --width=750 --height=260 \
				   --text="$message_validation" \
				   --title="$titre" \
				   --separator=":" \
				   ---radiolist  ---column "Choix" --column "Type de matériel" \
				   TRUE "Tour + Ecran + Clavier/Souris" \
				   FALSE "Tour + Clavier/Souris" \
				   FALSE "Tour"  \
				   FALSE "Portable + Adaptateur" \
				   FALSE "Portable sans Adaptateur" \
				   FALSE "Champ de renseignement libre" )
						
	if [[ ${description} == "Champ de renseignement libre"  ]] 
	then	
		description=$(zenity --entry --title="Descriptif ordinateur" --text="Saisissez le descriptif de l'ordinateur en vente :" --entry-text "Zone de saisie")
	fi						
						
	prix_vente=$(zenity --entry --title="Prix de vente" --text="Saisissez le prix de vente de l'ordinateur en € (Euros) :" --entry-text "$prix_vente")
	
	
	if [[ ${prix_vente} == "" || ${description} == ""  ]] 
	then
		echo "Erreur : Description ou prix incorrect !"
	else
		echo "#Fiche de description de la machine, et de son prix de vente" > ${fiche_vente} 
		echo "description=\"${description}\"" >> ${fiche_vente} 	   
		echo "prix_vente=${prix_vente}" >> ${fiche_vente} 	  
	fi

fi


if [[ ${prix_vente} == "" || ${description} == ""  ]] 
then
    zenity --error --title="Erreur de saisie" --text="$message_erreur_saisie"
else
    sudo ./prix_emmaus.sh ${prix_vente} "${description} : "	   
fi


