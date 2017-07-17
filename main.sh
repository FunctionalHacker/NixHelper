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

	if [ ! -f "$installpath" ]; then
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
	fi

	if [ "$#" -lt 1 ]; then
		echo -e "\e[31merror: \e[39mno operation specified (-h for help)"
		exit
	fi
fi

	case $1 in
		-h|--help)
			echo "This program is designed to fetch commands from a server"
			echo "and run them. Full list of working commands aliases"
			echo "here: https://nixhelper.reekynet.com"
			echo " "
			echo "Usage: nixhelper <alias/command> <parameters>"
			echo "Commands:"
			echo "   nixhelper {-h --help}    Shows this help"
			echo "   nixhelper {-u --update}  Updates Nixhelper"
			echo "   nixhelper {-v --version} Shows the current version"
			echo "   nixhelper {-r --remove}  Uninstalls Nixhelper"
			exit
			;;
		code|home)
			echo -e "\e[31merror: \e[39mcommand not found (-h for help)"
			exit
			;;
		-u|--update)
			wget -q -O nixhelper "$code"
			sudo chmod +x nixhelper
			sudo rm $installpath
			sudo mv nixhelper $installpath
			echo "Nixhelper updated to the latest version"
			exit
			;;
		-v|--version)
			echo "Nixhelper version: $version"
			exit
			;;
		-r|--remove)
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
			;;
		*)
	esac
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

		eval $outcommand
