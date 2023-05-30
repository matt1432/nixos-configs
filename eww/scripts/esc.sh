### this is a WIP
while :
do
	if [[ $(eww state) ]]; then
		read -s -n1  key

		case $key in
			$'\e') break;
		esac
	fi
done

eww close-all
