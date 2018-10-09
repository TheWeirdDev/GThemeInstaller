#!/bin/bash

sudo rm /usr/lib/gthemeinstaller/*
sudo rm /usr/bin/gthemeinstaller
sudo rm /usr/share/applications/gthemeinstaller.desktop
sed -i '/gthemeinstaller.desktop/d'  ~/.local/share/applications/mimeapps.list
echo "Done."