#!/usr/bin/env bash  

get_accents() {
  accents="$(coloryou /tmp/cover.jpg | sed 's/,//g' | sed 's/}//' | sed 's/'\''//g')"
  music_accent=$(echo "$accents" | awk '{ print $2 }')
  eww update music_accent="$music_accent"
  
  button_accent=$(echo "$accents" | awk '{ print $4 }')
  eww update button_accent="$button_accent"
  
  button_text=$(echo "$accents" | awk '{ print $6 }')
  eww update button_text="$button_text"
}

get_cover() {
  existing_file="/tmp/cover.jpg"
  new_image_url=$(playerctl -p spotify metadata mpris:artUrl)
  existing_hash=$(md5sum "$existing_file" | awk '{print $1}')

  # Download the new image only if the hashes are different
  if [[ "$(wget -qO- "$new_image_url" | md5sum | awk '{print $1}')" != "$existing_hash" ]]; then
    wget -qO "$existing_file" "$new_image_url"
    get_accents
  fi

  if [[ -f "/tmp/cover.jpg" ]]; then
    echo "/tmp/cover.jpg"
  else
    echo "randomfile"
  fi
}

[[ "$1" == "accents" ]] && get_accents
[[ "$1" == "cover" ]] && get_cover
