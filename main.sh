#!/bin/bash

version="0.3-alpha"

commandfile="/tmp/$1"
url="http://nixhelper.reekynet.com/$1"
code="http://nixhelper.reekynet.com/code"
installpath="/usr/local/bin/nixhelper"
wget="$(command -v wget)"

if [ "$wget" != "/usr/bin/wget" ]; then
        echo -e "\e[31mwget \e[39mis not installed."
        echo "Please install it using the package manager"
        echo "of your operating system"
        exit

elif [ ! -f "$installpath" ]; then
        echo "Nixhelper is not installed."
        read -p "Do you want to install now? [y/n]: " wantinstall
        if [ "$wantinstall" == "y" ]; then
              wget -q -O nixhelper "$code"
              sudo chmod +x nixhelper
              sudo mv nixhelper $installpath
              echo "Nixhelper is now installed"
              echo -e "Use \e[32mnixhelper -h \e[39mto get started"
              exit
        else
              echo "OK, exiting now."
              exit
        fi

elif [ "$#" -lt 1 ]; then
        echo -e "\e[31merror: \e[39mno operation specified (-h for help)"
        exit

elif [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        echo "This program is designed to fetch commands from a server"
        echo "and run them. Full list of working commands aliases"
        echo "here: http://nixhelper.reekynet.com"
        echo " "
        echo "Usage: nixhelper <alias/command> <parameters>"
	echo "Commands:"
	echo "   nixhelper {-h --help}    Shows this help"
	echo "   nixhelper {-u --update}  Updates Nixhelper"
	echo "   nixhelper {-v --version} Shows the current version"
	echo "   nixhelper {-r --remove}  Uninstalls Nixhelper"
        exit

elif [ "$1" == "code" ] || [ "$1" == "home" ]; then
        echo -e "\e[31merror: \e[39mcommand not found (-h for help)"
        exit

elif [ "$1" == "-u" ] || [ "$1" == "--update" ]; then
        wget -q -O nixhelper "$code"
        sudo chmod +x nixhelper
        sudo rm $installpath
        sudo mv nixhelper $installpath
        echo "Nixhelper updated to the latest version"
        exit

elif [ "$1" == "-v" ] || [ "$1" == "--version" ]; then
        echo "Nixhelper version: $version"
        exit

elif [ "$1" == "-r" ] || [ "$1" == "--remove" ]; then
	read -p "Are you sure you want to uninstall Nixhelper? [y/n]: " confirm
	if [ "$confirm" == "y" ]; then
		echo "Uninstalling Nixhelper"
		sudo rm /usr/local/bin/nixhelper
		echo "Done"
	else
		echo "Cancelling uninstallation"
		exit
	fi
	exit
fi

wget -q -O "$commandfile" "${url}"

if [ $? -ne 0 ]; then
        echo -e "\e[31merror: \e[39mcommand not found (-h for help)"
        exit
fi

outcommand=$(<$commandfile)
rm $commandfile

for i in "${*:2}"; do
    outcommand="$outcommand $i"
done

echo "Command to be executed: $outcommand"
read -p "Do you want to execute the command? [y/n]: " allow
if [ "$allow" == "y" ]; then
  eval $outcommand
  exit
else
  echo "Command not executed"
  echo "Exiting"
  exit
fi
