description[0]="Smasher of stacks"
description[1]="I <3 systems"


size=${#description[@]}
index=$(($RANDOM % $size))

sed -i "s|TAGLINE|${description[$index]}|" "./config.toml"
cd content || exit
find . -name '*.md' | while read -r file; do
	date="$(git log -1 --format=%ci "$file")"
	sed -i "s|DATE|$date|" "$file"
done
