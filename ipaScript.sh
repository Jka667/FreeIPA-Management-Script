#!/bin/bash

DateHeure=$(date "+%d/%m/%Y %H:%M:%S")
suffixe= domainname
afficher_menu() {
  clear
  echo -e " ================================ "
  echo -e " ================================ "
  echo -e " =====  $DateHeure   ============= "
  echo -e " ==============================="
  echo -e "================================"
  echo -e " ====== Menu de gestion FreeIPA ===="
  echo -e " ==== Suffixe: $suffixe ===="
  echo -e " ================================ "
  echo -e "\033[1;32m1)\033[0m afficher les utilisateurs"
  echo -e "\033[1;32m2)\033[0m afficher les groupes"
  echo -e "\033[1;32m3)\033[0m afficher les membres d'un groupe"
  echo -e "\033[1;32m4)\033[0m afficher les groupes d'un compte"
  echo -e "\033[1;33m5)\033[0m ajouter un utilisateur"
  echo -e "\033[1;33m6)\033[0m ajouter un groupe"
  echo -e "\033[1;33m7)\033[0m Ajouter un compte à un groupe"
  echo -e "\033[1;33m8)\033[0m Ajouter un groupe à un groupe"
  echo -e "\033[1;31m9)\033[0m Enlever un compte d'un groupe"
  echo -e "\033[1;31m10)\033[0m Reinitialiser mot de passe d'un compte"
  echo -e "\033[1;34m11)\033[0m Quitter"
  echo -e "\033[1;36m======================================================\033[0m"
  echo -n "Choisissez une option : "
}


# voici mes fonctions pour faire les differentes commandes IPa Sous forme de fonction c'est plus simple.


afficher_utilisateurs() {
  echo -e "\033[1;34m=== Liste des utilisateurs ===\033[0m"
  ipa user-find | grep 'User login:' | awk '{print $3}'
}

Afficher_groupes() {
  echo -e "\033[1;34m=== Liste des groupes ===\033[0m"
  ipa group-find | grep 'Group name:' | awk '{print $3}'
}

afficher_membres_groupe() {
  Afficher_groupes
  echo -n "Veuillez entrez le nom du groupe : "
  read groupe
  echo -e " membres du groupe :"
  ipa group-show "$groupe" | grep 'Member users:' | cut -d':' -f2 | tr -d ' '
}

afficher_groupes_compte() {
  afficher_utilisateurs
  echo -n "Veuillez Entrez le nom du compte : "
  read compte
  echo -e "\033[1;34m=== Groupes de l'utilisateur $compte ===\033[0m"
  ipa user-show "$compte" | grep 'Member of groups:' | cut -d':' -f2 | tr -d ' '
}

ajouter_utilisateur() {
  echo -n "Veuillez entrez le nom d'utilisateur : "
  read utilisateur
  echo -n "Entrez le prenom : "
  read prenom
  echo -n "Entrez le nom de famille : "
  read nom
  ipa user-add "$utilisateur" --first="$prenom" --last="$nom" --password
}

ajouter_groupe() {
  echo -n "Entrez le nom du groupe : "
  read groupe
  ipa group-add "$groupe"
}

ajouter_compte_a_groupe() {
  afficher_utilisateurs
  Afficher_groupes
  echo -n "Entrez le nom du compte : "
  read compte
  echo -n "Entrez le nom du groupe : "
  read groupe
  ipa group-add-member "$groupe" --users="$compte"
}

ajouter_groupe_a_groupe() {
  afficher_groupes
  echo -n "Entrez le groupe à ajouter : "
  read sous_groupe
  echo -n "Entrez le groupe cible : "
  read groupe
  ipa group-add-member "$groupe" --groups="$sous_groupe"
}

enlever_compte_de_groupe() {
  afficher_utilisateurs
  Afficher_groupes
  echo -n "Entrez le nom du compte : "
  read compte
  echo -n "Entrez le nom du groupe : "
  read groupe
  ipa group-remove-member "$groupe" --users="$compte"
}

reinitialiser_mot_de_passe() {
  afficher_utilisateurs
  echo -n "Entrez le nom du compte : "
  read compte
  ipa passwd "$compte"
}



#cette partie va gerer le choix dans  mon menu

while true; do
  afficher_menu
  read choix
  case $choix in
    1) afficher_utilisateurs ;;
    2) Afficher_groupes ;;
    3) afficher_membres_groupe ;;
    4) afficher_groupes_compte ;;
    5) ajouter_utilisateur ;;
    6) ajouter_groupe ;;
    7) ajouter_compte_a_groupe ;;
    8) ajouter_groupe_a_groupe ;;
    9) enlever_compte_de_groupe ;;
    10) reinitialiser_mot_de_passe ;;
    11) echo -e "\033[1;31mQuitter... À bientôt !\033[0m"; break ;;
    *) echo -e "\033[1;31mOption invalide ! Veuillez réessayer.\033[0m" ;;
  esac
  echo -e "\nAppuyez sur une touche pour continuer..."
  read -n 1
done
