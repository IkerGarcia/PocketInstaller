#!/bin/bash

if hash mednafen 2>/dev/null; then
  :
else
  P1="Mednafen(GB,GBA,NES,SNES,NPC)|./Installers/mednafen.sh"
fi
if hash vice 2>/dev/null; then
  :
else
  P2="Vice(C64,C128)|./Installers/vice.sh"
fi
if hash prboom  2>/dev/null; then
  :
else
  P3="Doom|./Installers/doom.sh"
fi

menu=($P1 $P2 $P3)
  
yad_opts=(--form
--scroll
--text="Install Software"
--image="./icon.png"
--button="Install" --button="Exit" )

for m in "${menu[@]}"
do
yad_opts+=( --field="${m%|*}:CHK" )
done

IFS='|' read -ra ans < <( yad "${yad_opts[@]}" )

for i in "${!ans[@]}"
do
if [[ ${ans[$i]} == TRUE ]]
then
m=${menu[$i]}
name=${m%|*}
cmd=${m#*|}
echo "selected: $name ($cmd)"
$cmd
fi
done
