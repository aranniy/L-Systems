# L-Systemes

"Les L-Systèmes" — Projet 2023-2024 pour l'UE XML !

Membres du binôme :

- LIM Victoria 22009116
- LINGESWARAN Aranniy 21954032

Pour tester le projet :

- pour générer le XML complet de l-systems : `make`
- pour valider le XML de l-systems : `make validate_lsystem`
- pour appliquer le xslt de tortue sur un système : `make tortue n=(nom de la lsystem) i=(nombre d'itération)`
- pour valider le XML de tortue : `make validate_tortue`
- pour appliquer le xslt de traceur sur une tortue : `make traceur`
- pour valider le XML de traceur : `make validate_traceur`
- pour appliquer le xslt de svg sur un traceur : `make svg`
- pour effacer tous les fichiers générés : `make clean`

Exemple : Essayez d'afficher le L-Système "snow" avec "5" itérations !