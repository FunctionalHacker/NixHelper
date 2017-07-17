#!/bin/bash

version="1.0"

cache="$HOME/.cache/nixhelper"
commandFile="$cache/$1"
url="https://nixhelper.reekynet.com/$1"
code="https://nixhelper.reekynet.com/code"
installPath="/usr/local/bin/nixhelper"
wget="$(command -v wget)"
downloadCommand="wget -q -O "$commandFile" "${url}""
confirmInstall=" "

function install (){
	if [ -f $installPath ]; then
		eval "rm $installPath"
	fi

	if [ ! -d "$cache" ]; then
		eval "mkdir $cache"
	fi

	eval "sudo wget -q -O $installPath $code; sudo chmod +x $installPath"
}

function manage (){
	local action=${1}
	case $action in
		"install")
			echo "Are you sure you want to install NixHelper?"
			echo "This action will require administrative rights."
			read -p "[y/n]: " confirmInstall
			if [ $confirmInstall == "y" ]; then
				install
				echo "NixHelper is now installed"
				echo -e "Use \e[32mnixhelper -h \e[39mto get started"
			fi
			exit
			;;
		"update")
			echo "Are you sure you want to update NixHelper?"
			echo "This action will require administrative rights."
			read -p "[y/n]: " confirmInstall 
			if [ $confirmInstall == "y" ]; then
				install
				echo "NixHelper updated to the latest version"
				echo -e "Use \e[32mnnixhelper -h \e[39mto see which version is installed"
			fi
			exit
			;;
		"remove")
			echo "Are you sure you want to remove NixHelper from your computer?"
			echo "This action will require administrative rights."
			read -p "[y/n]: " confirmInstall
			if [ $confirmInstall == "y" ]; then
				eval "sudo rm $installPath; sudo rm -r $cache"
				echo "NixHelper is now uninstalled."
				echo "Visit https://nixhelper.reekynet.com if you want to install"
				echo "it again"
			else
				echo "Cancelling removal of NixHelper."
			fi
			exit
			;;
		"clear")
			echo "Are you sure you want to clear the command cache?"
			echo "This means that you need to verify every command again"
			echo "that you asked NixHelper to remember as trusted"
			read -p "[y/n]: " clearVerify

			if [ $clearVerify == "y" ]; then
				eval "rm $cache/*"
				echo "Cache cleared"
				exit
			else
				echo "Cancelling clearing of the cache"

			fi
			;;
		"check")
			if [ ! -f $installPath ]; then
				manage install
			fi
			;;
	esac
}



function parseCommand (){
	command=$(<$commandFile)

	for i in "${*:2}"; do
		command="$command $i"
	done
}

function verifyCommand (){
	echo "Are you sure you want to execute this command?"
	echo -e "The command behind the alias \e[31m$1\e[39m is:"
	eval "$downloadCommand"
	parseCommand "$@"
	echo -e "\e[31m$command\e[39m"
	read -p "[y/n/a] (yes/no/always): " confirmCommand

	case $confirmCommand in
		"y")
			echo "Executing the command without saving your choice"
			echo "To disable this confirmation run the command again and select [a]"
			eval "rm $commandFile"
			;;
		"n")
			echo "Cancelling the execution of the command"
			eval "rm $commandFile"
			exit
			;;
		"a")
			echo "Executing command and saving it in the cache"
			echo "This confirmation will not be asked again"
			echo "If you would like to clear the cache, run nixhelper -c"
			;;
		*)
			echo "Invalid selection, please try again"
	esac
}

function help (){
	echo "This program is designed to fetch commands from a server"
	echo "and run them. Full list of working commands aliases"
	echo "can be found here: https://nixhelper.reekynet.com"
	echo " "
	echo "Usage: nixhelper <alias/command> <parameters>"
	echo "Commands:"
	echo "   nixhelper {-h --help}    Shows this help"
	echo "   nixhelper {-u --update}  Updates NixHelper"
	echo "   nixhelper {-v --version} Shows the current version"
	echo "   nixhelper {-r --remove}  Removes NixHelper from your computer"
	echo "   nixhelper {-c --clear}  Clears the command cache"
	exit

}

manage check

if [ "$#" -lt 1 ]; then
	echo -e "\e[31merror: \e[39mno operation specified (-h for help)"
	exit
fi

case $1 in
	"-h"|"--help")
		help
		;;
	"code"|"home")
		echo -e "\e[31merror: \e[39mcommand not found (-h for help)"
		exit
		;;
	"-u"|"--update")
		manage update
		;;
	"-v"|"--version")
		echo "NixHelper version: $version"
		exit
		;;
	"-r"|"--remove")
		manage remove
		;;
	"-c"|"--clear")
		manage "clear"
		;;
	*)
esac

if [ ! -f $commandFile ]; then
	verifyCommand "$@"
else
	parseCommand "$@"
fi

if [ $? -ne 0 ]; then
	echo -e "\e[31merror: \e[39mcommand not found (-h for help)"
	exit
fi

eval $command
