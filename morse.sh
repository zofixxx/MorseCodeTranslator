#!/bin/bash
# Author           : Zosia Drożdż 194319
# Created On       : 27.05.2024
# Last Modified By : Zosia Drożdż 194319

declare -A morse
morse=(
[A]="._"
[B]="_..."
[C]="_._."
[D]="_.."
[E]="."
[F]=".._."
[G]="__."
[H]="...."
[I]=".."
[J]=".___"
[K]="_._"
[L]="._.."
[M]="__"
[N]="_."
[O]="___"
[P]=".__."
[Q]="__._"
[R]="._."
[S]="..."
[T]="_"
[U]=".._"
[V]="..._"
[W]=".__"
[X]="_.._"
[Y]="_.__"
[Z]="__.."
[1]=".____"
[2]="..___"
[3]="...__"
[4]="...._"
[5]="....."
[6]="_...."
[7]="__..."
[8]="___.."
[9]="____."
[0]="_____"
["."]="._._._"
[","]="__..__"
[":"]="___..."
[";"]="_._._."
["?"]="..__.."
["!"]="_._.__"
[" "]="|"
)

# Converting text to Morse code
latinToMorse() {
	local text="$1"
	local result=""
	for ((i=0; i<${#text}; i++)); do
		char="${text:$i:1}"
		if [[ "$char" =~ [a-z] ]]; then
			char=${char^^}
		fi
		if [[ -n "${morse[$char]}" ]]; then
			result+="${morse[$char]} "
		else
			result+=" "
		fi
	done
	echo "$result"
}

# Converting Morse code to text (latin alphabet)
morseToLatin() {
	local code="$1"
	local result=""
	local IFS=" "
	read -r -a  morseCode <<< "$code"
	for word in "${morseCode[@]}"; do
		if [[ "$word" == "|" ]]; then
			result+=" "
		else
			for letter in "${!morse[@]}"; do
				if [[ "${morse[$letter]}" == "$word" ]]; then
					result+="$letter"
					break
				fi
			done
		fi
	done
	echo "$result"
}

# Script instructions using getopts
while getopts ":ht:m:" opt; do
	case ${opt} in
		h )
			zenity --info --title="HELP" --text="Usage example: $(basename $0) [-h] [-t \"TEXT\"] [-m \"MORSE\"]\n\n -h                         Display help message\n -t \"TEXT\"          Translate text to Morse code\n -m \"MORSE\"  Translate Morse code to text (use \"|\" to seperate words)\nDON'T USE POLISH LETTERS!"
			exit 0
			;;
		t )
			text="$OPTARG"
			morse=$(latinToMorse "$text")
			zenity --info --title="TRANSLATION TO MORSE CODE" --text="Morse code: $morse"
			exit 0
			;;
		m )
			morse="$OPTARG"
			text=$(morseToLatin "$morse")
			zenity --info --title="TRANSLATION TO TEXT" --text="Text: $text"
			exit 0
			;;
		: )
			zenity --error --title="ERROR" --text="Option -$OPTARG requires an argument"
			exit 1
			;;
		\? )
			zenity --error --title-"ERROR" --text="Invalid option -$OPTARG"
			exit 1
			;;
	esac
done

# Default script instructions
choice=$(zenity --list --title="MORSE CODE TRANSLATOR" --column="Choose an option" "Text to Morse" "Morse to Text")

if [ "$choice" == "Text to Morse" ]; then
	text=$(zenity --entry --title="TRANSLATION TO MORSE CODE" --text="Enter text to translate:")
	if [ -n "$text" ]; then
		morse=$(latinToMorse "$text")
		zenity --info --title="TRANSLATION" --text="Morse code:\n$morse"
	else
		zenity --error --title="ERROR" --text="No input provided"
	fi
elif [ "$choice" == "Morse to Text" ]; then
	morse=$(zenity --entry --title="TRANSLATION TO TEXT" --text="Enter morse code to translate (use '|' to seperate words)")
	if [ -n "$morse" ]; then
		text=$(morseToLatin "$morse")
		zenity --info --title="TRANSLATION" --text="Text:\n$text"
	else
		zenity --error --title="ERROR" --text="No input provided"
	fi
else
	zenity --error --title="ERROR" --text="No option selected"
fi


