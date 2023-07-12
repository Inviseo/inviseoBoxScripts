cd
rm -rf rtl88x2bu
git clone https://github.com/cilynx/rtl88x2bu.git
cd rtl88x2bu
sudo make backup_rtlwifi
make
sudo make install
sudo modprobe 88x2bu
