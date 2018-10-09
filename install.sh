#!/bin/bash

echo "Installing ..."

sudo mkdir -p /usr/lib/gthemeinstaller/

sudo cp main.rb url_parser.rb /usr/lib/gthemeinstaller/
sudo chmod +x /usr/lib/gthemeinstaller/main.rb
sudo ln -s /usr/lib/gthemeinstaller/main.rb /usr/bin/gthemeinstaller
sudo chmod +x /usr/bin/gthemeinstaller

sudo cp gthemeinstaller.desktop /usr/share/applications/
sudo chmod +x  /usr/share/applications/gthemeinstaller.desktop
echo 'x-scheme-handler/ocs=gthemeinstaller.desktop' >>  ~/.local/share/applications/mimeapps.list
echo "Done."