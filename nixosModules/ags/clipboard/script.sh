set +o errexit

# Modified from https://github.com/sentriz/cliphist/blob/master/contrib/cliphist-wofi-img

# set up thumbnail directory
thumb_dir="/tmp/cliphist/thumbs"
mkdir -p "$thumb_dir"

cliphist_list="$(cliphist list)"

# delete thumbnails in cache but not in cliphist
for thumb in "$thumb_dir"/*; do
    clip_id="${thumb##*/}"
    clip_id="${clip_id%.*}"
    check=$(rg <<< "$cliphist_list" "^$clip_id\s")
    if [ -z "$check" ]; then
        >&2 rm -v "$thumb"
    fi
done

# create thumbnail if image not processed already
read -r -d '' prog <<EOF
/^[0-9]+\s<meta http-equiv=/ { next }

match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
    image = grp[1]"."grp[3]
    system("[ -f $thumb_dir/"image" ] || echo " grp[1] "\\\\\t | cliphist decode | convert - -resize '256x256>' $thumb_dir/"image )
    print "img:$thumb_dir/"image
    next
}

1
EOF

output=$(gawk <<< "$cliphist_list" "$prog")

# Use a while loop with read to iterate over each line
echo "$output" | while IFS= read -r line; do
    if [[ ! $line =~ ^img:/tmp/cliphist/thumbs ]]; then
        [[ $line =~ ([0-9]+) ]]
        line=${BASH_REMATCH[1]}
    fi

    echo "$line"
done
