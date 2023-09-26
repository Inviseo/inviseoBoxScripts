#!/bin/bash

# Fonction à exécuter si la réponse est "Yes"
function yes_function() {
    echo "Activation de l'interface graphique"
    sudo systemctl set-default graphical.target
}

# Fonction à exécuter si la réponse est "No"
function no_function() {
    echo "Desactivation del'interface graphique"
    sudo systemctl set-default multi-user.target
}

# Posez la question à l'utilisateur
read -p "Voulez-vous activer l'interface graphique (Yes/No): " response

# Convertit la réponse en minuscules pour une comparaison insensible à la casse
response_lower=$(echo "$response" | tr '[:upper:]' '[:lower:]')

# Vérifie la réponse et appelle la fonction appropriée
if [ "$response_lower" = "yes" ]; then
    yes_function
elif [ "$response_lower" = "no" ]; then
    no_function
else
    echo "Réponse non valide. Utilisez 'Yes' ou 'No'."
fi
echo "Pensez à redémarrer le système pour appliquer les changements"
echo "Fin du paramétrage"
