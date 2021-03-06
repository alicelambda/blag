description[0]="Smasher of stacks"
description[1]="I <3 systems"
description[2]="Console Cowgirl"

offset[0]="80"
offset[1]="125"
offset[2]="100"

size=${#description[@]}
index=$(($RANDOM % $size))

sed -i "s|TAGLINE|${description[$index]}|" "./config.toml"
sed -i "s|OFFSET|${offset[$index]}|" "./themes/solar-theme-hugo/layouts/_default/list.html"
cd content || exit
find . -name '*.md' | while read -r file; do
	date="$(git log -1 --format=%ci "$file")"
	sed -i "s|DATE|$date|" "$file"
done
