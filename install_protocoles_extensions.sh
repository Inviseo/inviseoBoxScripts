#!/bin/bash
echo "Installation protocoles extensions"
echo "----------------------------------"
echo "Needs :"
echo "Install GIT"
sudo apt install git -y

function installVISA() {
    echo "install VISA"
    git clone https://github.com/pyscada/PyScada-VISA.git
    cd PyScada-VISA
    activatePlugin
    cd ..
}

function installBacNet() {
    echo "Install BackNet"
    git clone https://github.com/pyscada/PyScada-BACnet.git
    cd PyScada-BACnet
    activatePlugin
    cd ..
}

function installModbus() {
    echo "install Modbus"
    git clone https://github.com/pyscada/PyScada-Modbus.git
    cd PyScada-Modbus
    activatePlugin
    cd ..
}

function installSystemStat() {
    echo "install system Stat"
    git clone https://github.com/pyscada/PyScada-SystemStat.git
    cd PyScada-SystemStat
    activatePlugin
    cd ..
}

function installSMBus() {
    echo "instal SM Bus"
    git clone https://github.com/pyscada/PyScada-SMBus.git
    cd PyScada-SMBus
    activatePlugin
    cd ..
}

function installOneWire() {
    echo "install OneWire"
    git clone https://github.com/pyscada/PyScada-Onewire.git
    cd PyScada-Onewire
    activatePlugin
    cd ..
}

function installOPCUA() {
    echo "install OPCUA"
    git clone https://github.com/pyscada/PyScada-OPCUA.git
    cd PyScada-OPCUA
    activatePlugin
    cd ..
}

function installMeterBus() {
    echo "install Meter Bus"
    git clone https://github.com/pyscada/PyScada-MeterBus.git
    cd PyScada-MeterBus
    activatePlugin
    cd ..
}

function installGPIO() {
    echo "install GPIO"
    git clone https://github.com/pyscada/PyScada-GPIO.git
    cd PyScada-GPIO
    activatePlugin
    cd ..
}

function installScripting() {
    echo "install scripting extension"
    git clone https://github.com/pyscada/PyScada-Scripting.git
    cd PyScada-Scripting
    activatePlugin
    cd ..
}

function installPhant() {
    echo "install Phant extension"
    git clone https://github.com/pyscada/PyScada-Phant.git
    cd PyScada-Pant
    activatePlugin
    cd ..
}

function installSML() {
    echo "install SML extension"
    git clone https://github.com/pyscada/PyScada-SML.git
    cd PyScada-SML
    activatePlugin
    cd ..
}

function installLaboREM() {
    echo "install LaboREM extension"
    git clone https://github.com/pyscada/PyScada-LaboREM.git
    cd PyScada-LaboREM
    activatePlugin
    cd ..
}
function installWebService() {
    echo "install WebService"
    git clone https://github.com/clavay/PyScada-WebService.git
    cd PyScada-WebService
    activatePlugin
    cd ..
}

function activatePlugin() {
    # activate the PyScada virtual environment
    source /home/pyscada/.venv/bin/activate
    # install the plugin
    sudo -E env PATH=${PATH} pip install .
    # run migrations
    python3 /var/www/pyscada/PyScadaServer/manage.py migrate
    # copy static files
    python3 /var/www/pyscada/PyScadaServer/manage.py collectstatic --no-input
    # restart gunicorn and PyScada
    sudo systemctl restart gunicorn pyscada
}

PS3='Enter plugin would you install: '
    plugins=("Modbus" "WebService" "Scripting" "Quit")
    select plug in "${plugins[@]}"; do
        case $plug in
            "Modbus")
            installModbus
            break
            ;;
            "WebService")
            installWebService
            break
            ;;
            "Scripting")
            installScripting
            break
            ;;
            "Quit")
            exit
            ;;
            *) echo "Invalid option";;
        esac
done

# installModbus

# installSystemStat

# installBacNet

# installVISA

# installSMBus

# installOneWire

# installOPCUA

# installMeterBus

# installGPIO

# installScripting

# installPhant

# installSML

# installLaboREM
