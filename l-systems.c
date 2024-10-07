#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* taille max d'un élément (200 : choix arbitraire) */
#define TAILLE_MAX 200

/* affichage des erreurs */
void gestion_erreur(const char *message) {
    perror(message);
    exit(1);
}

int main() {

    /* fichiers */
    FILE *lsystems_cvc = fopen("l-systems.csv","r");
    FILE *lsystems_xml = fopen("generated/l-systems_complet.xml","w");

    /* variables */
    char line[TAILLE_MAX];
    char nom[TAILLE_MAX];
    char chaines[TAILLE_MAX];
    char axiome[TAILLE_MAX];
    char substitution_interpretation[TAILLE_MAX];
    char substitution[TAILLE_MAX];
    char interpretation[TAILLE_MAX];
    char *token;
    char *token2;
    char *save_substitution;
    char *save_interpretation;
    int id = 1;
    
    /* gestion des erreurs */
    if (lsystems_cvc == NULL || lsystems_xml == NULL) {
        gestion_erreur("ouverture fichiers");
    }

    /* entête */
    fprintf(lsystems_xml, "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\n");
    //fprintf(lsystems_xml, "<!DOCTYPE lsystems>\n");
    fprintf(lsystems_xml, "<lsystems>\n");

    /* boucle qui traite chaque ligne du fichier cvc */
    while (fgets(line, sizeof(line), lsystems_cvc) != NULL) {

        /* on récupère chaque élément de la ligne */
        if (sscanf(line,"%[^,],%[^,],%[^,],%[^\n]", nom, chaines, axiome, substitution_interpretation) != 4) {
            gestion_erreur("sscanf");
        }

         /* on compte le nombre de virgule pour pouvoir séparer substitution et interprétation */
        int nbr_virgule = 0;
        for (int i = 0; substitution_interpretation[i] != '\0'; i++) {
            if (substitution_interpretation[i] == ',') {
                nbr_virgule++;
            }
        }

        /* on arrondit à la valeur au dessus */
        int nbr_substitutions = (nbr_virgule + 1) / 2;

        /* on sépare substitution_interpretation en substitution et interpretation */
        token = strtok(substitution_interpretation, ",");
        if (token == NULL ) {
            gestion_erreur("token ligne 66");
        }
        strcpy(substitution, token);

        for (int i = 1; i < nbr_substitutions; i++) {

            if (token == NULL ) {
                gestion_erreur("token ligne 73");
            }

            token = strtok(NULL, ",");
            strcat(substitution, ",");
            strcat(substitution, token);
        }

        if (token == NULL ) {
            gestion_erreur("token ligne 82");
        }

        strcpy(interpretation, strtok(NULL, "\n"));

        fprintf(lsystems_xml,"    <lsystem id=\"LS%d\">\n", id++);
        fprintf(lsystems_xml,"        <nom>%s</nom>\n", nom);

        fprintf(lsystems_xml,"        <axiome>\n");

        for (int i = 0; i < strlen(axiome); i++) {
            fprintf(lsystems_xml,"            <symbole>%c</symbole>\n", axiome[i]); 
        }

        fprintf(lsystems_xml,"        </axiome>\n");

        token = strtok_r(substitution, ",", &save_substitution);
        token2 = strtok_r(interpretation, ",", &save_interpretation);

        fprintf(lsystems_xml,"        <regles>\n");

        for (int i = 0; chaines[i] != '\0'; i++) {

            if (token == NULL || token2 == NULL) {
                gestion_erreur("mauvais nombre d'images/instructions");
            }

            char command[20]; 
            char value[20];
            char *token3 = strtok(token2, " ");
            if (token3 != NULL) {
                strcpy(command, token3);
                token3 = strtok(NULL, " "); 
            }
            
            if (token3 != NULL) {
                strcpy(value, token3);
            }

            fprintf(lsystems_xml,"            <regle image=\"%s\" commande=\"%s\" angle=\"%d\">%c</regle>\n",token,command,atoi(value),chaines[i]);
            token = strtok_r(NULL, ",", &save_substitution);
            token2 = strtok_r(NULL, ",", &save_interpretation);
        }

        fprintf(lsystems_xml,"        </regles>\n");

        fprintf(lsystems_xml,"    </lsystem>\n");
    }

    fprintf(lsystems_xml,"</lsystems>\n");

    /* fermeture des fichiers */
    fclose(lsystems_cvc);
    fclose(lsystems_xml);

    return 0;
}
