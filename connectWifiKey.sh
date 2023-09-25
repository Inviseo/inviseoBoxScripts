#!/bin/bash

# Liste les interfaces réseau disponibles
echo "Interfaces réseau disponibles:"
interfaces=($(ip -o link show | awk -F': ' '{print $2}'))
num_interfaces=${#interfaces[@]}

for ((i=0; i<num_interfaces; i++)); do
  echo "$((i+1)). ${interfaces[i]}"
done

# Demande à l'utilisateur de choisir une interface
read -p "Choisissez le numéro de l'interface à utiliser : " interface_num

# Vérifie que l'entrée est un numéro valide
if ! [[ "$interface_num" =~ ^[0-9]+$ ]]; then
  echo "Choix invalide. Veuillez entrer un numéro valide."
  exit 1
fi

# Vérifie que le numéro de l'interface est dans la plage valide
if ((interface_num < 1)) || ((interface_num > num_interfaces)); then
  echo "Choix invalide. Le numéro doit être entre 1 et $num_interfaces."
  exit 1
fi

# Sélectionne l'interface choisie
selected_interface="${interfaces[interface_num-1]}"

# Liste les réseaux WiFi disponibles sur l'interface sélectionnée
echo "Réseaux WiFi disponibles sur l'interface $selected_interface :"
networks=($(sudo iw dev "$selected_interface" scan | grep "SSID:" | awk -F': ' '{print $2}'))
num_networks=${#networks[@]}

for ((i=0; i<num_networks; i++)); do
  echo "$((i+1)). ${networks[i]}"
done

# Demande à l'utilisateur de choisir un réseau WiFi
read -p "Choisissez le numéro du réseau WiFi auquel vous souhaitez vous connecter : " network_num

# Vérifie que l'entrée est un numéro valide
if ! [[ "$network_num" =~ ^[0-9]+$ ]]; then
  echo "Choix invalide. Veuillez entrer un numéro valide."
  exit 1
fi

# Vérifie que le numéro du réseau est dans la plage valide
if ((network_num < 1)) || ((network_num > num_networks)); then
  echo "Choix invalide. Le numéro doit être entre 1 et $num_networks."
  exit 1
fi

# Sélectionne le réseau WiFi choisi
selected_network="${networks[network_num-1]}"

# Demande un mot de passe si nécessaire
read -s -p "Entrez le mot de passe (si nécessaire) : " wifi_password

# Connecte l'interface au réseau WiFi choisi
echo "Connexion à $selected_network en cours..."
sudo nmcli device wifi connect "$selected_network" password "$wifi_password"
