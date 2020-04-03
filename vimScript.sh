#!/bin/bash
notify-send "Info" "Updating Vim"
time=`date +"%d-%b-%Y %H:%M"`
echo "[${time}] Updating vim" >> /opt/vim_log.txt
cd /opt/vim
git pull
cd src
make distclean
cd ..
./configure --with-features=huge \
            --enable-multibyte \
            --enable-pythoninterp=no \
            --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
            --enable-python3interp=yes \
            --with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-gui=auto \
            --enable-cscope \
            --prefix=/usr/local
make
sudo make install
time=`date +"%d-%b-%Y %H:%M"`
echo "[${time}] Vim updated" >> /opt/vim_log.txt
notify-send "Info" "Vim updated!!"
