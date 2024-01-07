#!/bin/bash
declare -A ERROR
# Config values
TypeSnow="*"
Velocity=0.1
LangScript="EN"
EXIT_ACTION="clear"
if [[ $LangScript == "EN" ]]; then
	EXIT_MESSAGE="Snow script closed."
	ERROR[1]="ERROR: letter or word required."
	ERROR[2]="ERROR: the parameter #2 must be a number [FROM 0-9]."
	ERROR[3]="ERROR: the parameter #4 must be a number [FROM 0-9]."
	ERROR[4]="ERROR: language unavailable."
	ERROR[5]="ERROR: snow is already installed?."
	ERROR[HELP]="-e PARAMETER INVALID\n\t-v [NUMBER] set the velocity of the snow.\n\t-s [SYMBOL or WORD] set the symbol '*' for a specific symbol."
	SETTING_LANGUAGE="New language setted:"
elif [[ $LangScript == "ES" ]]; then
	EXIT_MESSAGE="Snow script cerrado."
	ERROR[1]="ERROR: letra o palabra requerida."
	ERROR[2]="ERROR: el parametro #2 necesita ser un número [DESDE 0-9]."
	ERROR[3]="ERROR: el parametro #4 necesita ser un número [DESDE 0-9]."
	ERROR[4]="ERROR: lenguaje no disponible."
	ERROR[5]="ERROR: ¿snow ya está instalado?."
	ERROR[HELP]="-e PARAMETRO INVALIDO\n\t-v [NUMERO] cambia la velocidad de la nieve.\n\t-s [SIMBOLO O PALABRA] cambia el simbolo '*' por un simbolo especifico."
	SETTING_LANGUAGE="Nuevo lenguaje configurado:"
fi

clear
declare -A snowflakes lastflakes; declare -i LINES COLUMNS
LINES=$(tput lines)
COLUMNS=$(tput cols)

function switch_number() {
	number=$(echo $1 | grep -w '[0-9]')
	if [[ $number ]]; then echo $number; fi
}
		
case $1 in
"-s" | "--select")
	if [[ $2 ]]; then
	  if [[ ! $3 ]]; then
		TypeSnow=$2
	  elif [[ $3 == "-v" ]] || [[ $3 == "--velocity" ]]; then
	  	TypeSnow=$2
	  	number=$(echo `switch_number $4`)
	  	if [[ $number ]]; then Velocity=$number; else echo ${ERROR[3]}; exit; fi
	  fi
	else echo ${ERROR[1]}; exit
	fi
;;

"-v" | "--velocity")
	number=$(echo `switch_number $2`)
	if [[ $number ]]; then
	  if [[ ! $3 ]]; then
		Velocity=$number
	  elif [[ $3 == "-s" ]] || [[ $3 == "--select" ]]; then
	  	number=$(echo $(switch_number $2))
		if [[ $number ]]; then Velocity=$number; else echo ${ERROR[3]}; exit; fi
	  	TypeSnow=$4
	  fi
	else echo ${ERROR[2]}; exit
	fi
;;


"--help")
	echo ${ERROR[HELP]}
	exit
;;

"--lang")
	selected_lang=$(echo $2 | tr [:lower:] [:upper:])
	if [[ $selected_lang == "ES" ]] || [[ $selected_lang == "EN" ]]; then
		if [ -f "/usr/bin/snow" ]; then
			sed -i '6 s/'$LangScript'/'${selected_lang}'/g' /usr/bin/snow
			echo ${SETTING_LANGUAGE} ${selected_lang}
		else
			echo ${ERROR[5]}
		fi
	else echo ${ERROR[4]}
	fi
	exit
;;
*)
	if [[ $1 ]]; then echo ${ERROR[HELP]}; exit; fi
esac

function detect_exit() {
	trap '$EXIT_ACTION; echo $EXIT_MESSAGE; exit 127' SIGINT
}

function move_flake() {
i="$1"

if [ "${snowflakes[$i]}" = "" ] || [ "${snowflakes[$i]}" = "$LINES" ]; then
	snowflakes[$i]=0
else
	if [ "${lastflakes[$i]}" != "" ]; then
		printf "\033[%s;%sH \033[1;1H " ${lastflakes[$i]} $i
	fi
fi

printf "\033[%s;%sH\e[1;37m$TypeSnow\e[0m\033[1;1H" ${snowflakes[$i]} $i
lastflakes[$i]=${snowflakes[$i]}
snowflakes[$i]=$((${snowflakes[$i]}+1))
}

while true; do
	i=$(($RANDOM % $COLUMNS))
	move_flake $i
	for x in "${!lastflakes[@]}"; do
		move_flake "$x"
	done
sleep $Velocity
detect_exit
done
