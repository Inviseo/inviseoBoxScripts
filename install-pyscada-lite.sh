#!/bin/bash

# Variables globales
# Chemin du dossier à vérifier
dossier_installation_pyscada_lite="/var/www/pyscada_lite"
dossier_instalation_pyscada_lite_front="/var/www/pyscada_lite_front"
# chemin du script
chemin_actuel="$(pwd)"
chemin_avec_static="$chemin_actuel/pyscada-lite-back/config/static"
cd
# Vérifier si l'utilisateur est root ou utilise sudo
if [[ $EUID -ne 0 ]]; then
    echo "Ce script doit être exécuté en tant que root ou avec sudo."
    exit 1
fi

# Demander à l'utilisateur s'il souhaite une nouvelle installation ou une mise à jour
read -p "Voulez-vous effectuer une nouvelle installation (N) ou une mise à jour (M) ? " choix

# Convertir la réponse en majuscules pour la comparaison
choix_uppercase=$(echo "$choix" | tr 'a-z' 'A-Z')

# Installation des packages requis
echo "Installation des dependences systeme"
sleep 3
apt update
apt install -y git python3-pip sqlite3 npm nodejs nginx

# Clone du projet depuis GitHub
echo "Copie du depot github pyscada lite"
sleep 3
git clone https://github.com/vincent-inviseo/pyscada-lite-back.git
cd pyscada-lite-back

# Vérification et création de l'arborescence de dossier pour le logicie inviseo pyscada lite
# Vérifier si le dossier existe
echo "Verification de la présence des dossiers d'installation"
sleep 3
if [ -d "$dossier_installation_pyscada_lite" ]; then
    echo "Le dossier existe."
else
    echo "Le dossier n'existe pas. Création en cours..."
    mkdir -p "$dossier_installation_pyscada_lite"
    echo "Dossier créé avec succès : $dossier_installation_pyscada_lite"
fi

# Attribution des droits au dossier d'installation
echo "Attributions des droits aux dossiers et fichiers"
sleep 3
chown -R www-data:www-data $dossier_installation_pyscada_lite
chmod -R 777 $dossier_installation_pyscada_lite

# deplacement des fichiers django pyscada lite vers le dossier d'installation
echo "Deplacement des fichiers copiées vers le répertoire de production"
sleep 3
cp -rf * $dossier_installation_pyscada_lite
cd $dossier_installation_pyscada_lite

# collecte et migration des fichiers static
# Préparation du projet Django pour la production
echo "preparation des fichiers applicatif pour la production"
sleep 3
python3 manage.py collectstatic --noinput --clear 
python3 manage.py migrate

# Installation des dépendances Python
echo "Installation des dependances python du projet pyscada inviseo"
sleep 3
pip3 install -r requirements.txt --break-system-packages
sleep 3
if [ "$choix_uppercase" = "N" ]; then
    echo "Nouvelle installation"
    echo "Creation de l'administrateur pyscada lite"
    sleep 3
    # Demander l'adresse e-mail super admin
    read -p "Entrez l'adresse e-mail du super admin: " email

    # Activer l'environnement virtuel si nécessaire
    # source /chemin/vers/votre/environnement_virtuel/bin/activate

    # Exécuter la commande de création de super utilisateur Django
    python3 manage.py createsuperuser --username=admin --email="$email"

elif [ "$choix_uppercase" = "M" ]; then
    echo "Mise à jour"
else
    echo "Réponse non valide. Veuillez saisir 'N' pour nouvelle installation ou 'M' pour mise à jour."
fi

echo "Creation de la configuration serveur nginx"
sleep 3
# Création du fichier de configuration proxy pour Nginx
cat << EOF > /etc/nginx/sites-available/pyscada-lite-back.conf

server {
    listen 8000;
    server_name _;

    location = /favicon.ico { access_log off; log_not_found off; }

    location /static/ {
        root /var/www/pyscada-lite-back;
    }

    location / {
        proxy_set_header Host $host;
    	proxy_set_header X-Real-IP $remote_addr;
  	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    	proxy_set_header X-Forwarded-Proto $scheme;
        proxy_pass http://127.0.0.1:80;
    }

    location /media/ {
        root /var/www/pyscada-lite-back;
    }

    # Autres configurations de sécurité et de performances peuvent être ajoutées ici
}


EOF

echo "Activation du site local"
sleep 3
# Activation du fichier de configuration proxy
ln -s /etc/nginx/sites-available/pyscada-lite-back /etc/nginx/sites-enabled/

# Redémarrage de Nginx
echo "redemarrage des services nginx"
sleep 3
systemctl restart nginx

# Installation du service linux
echo "Installation du service linux pour l applicationpyscada lite"
sleep 3
cp -rf $dossier_installation_pyscada_lite/scripts/django_runserver.service /etc/systemd/system/
systemctl enable django_runserver.service
systemctl start django_runserver.service

# installation de la cron job
echo "Installation de la cronjob"
/var/www/pyscada_lite/scripts/conjob_getall_devices_variables.sh

cd
# Cloner le dépôt Git pyscada-lite-front
echo "clonage depot pyscada lite front"
sleep 3
git clone https://github.com/vincent-inviseo/pyscada-lite-front.git

# Se déplacer dans le répertoire du projet
cd pyscada-lite-front

# copie du fichier nginx frontal
echo "copie et activation du serveur nginx frontal"
sleep 3
cp ./server-config/pyscada-lite-nginx.conf /etc/nginx/sites-available
ln -s /etc/nginx/sites-available/pyscada-lite-nginx.conf /etc/nginx/sites-enabled/
# Redémarrage de Nginx
echo "redemarrage des services nginx"
sleep 3
systemctl restart nginx

# Installer les dépendances npm et yarn
echo "installation des dépendances système frontale"
sleep 3
sudo apt update -y
sudo apt install npm -y
npm install -g yarn

# Installer les dépendances du projet avec yarn
echo "installation de yarn"
sleep 3
yarn install

# Exécuter le script yarn build
echo "execution du la commande de mise en production"
sleep 3
yarn build

echo "Verification de la présence des dossiers d'installation frontal"
sleep 3
if [ -d "$dossier_installation_pyscada_lite_front" ]; then
    echo "Le dossier existe."
else
    echo "Le dossier n'existe pas. Création en cours..."
    mkdir -p "$dossier_installation_pyscada_lite_front"
    echo "Dossier créé avec succès : $dossier_installation_pyscada_lite_front"
fi

# copie des fichiers de de production pour le pyscada-lite-front
cp -r dist/pyscada-ui/* $dossier_installation_pyscada_lite_front

# Attribution des droits au dossier d'installation
echo "Attributions des droits aux dossiers et fichiers"
sleep 3
chown -R www-data:www-data $dossier_installation_pyscada_lite_front
chmod -R 777 $dossier_installation_pyscada_lite_front


echo "Le script a terminé l'installation et la configuration."
echo "Fini :) Pensez à verifier si le service tourne bien et que le back est accessible"
