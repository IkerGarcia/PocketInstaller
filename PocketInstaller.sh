#!/bin/bash

if hash zenity 2>/dev/null; then
  :
else
  sudo apt-get install zenity
fi
if hash yad 2>/dev/null; then
  :
else 
  echo "deb http://pkg.bunsenlabs.org/debian jessie-backports main" | sudo tee -a /etc/apt/sources.list
  sudo apt-get install yad
fi

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
if hash openttd 2>/dev/null; then
  :
else 
  P4="OpenTTD|./Installers/openttd.sh"
fi

menu=($P1 $P2 $P3 $P4)
  
yad_opts=(--form
--scroll
--text="Install Software"
--image="/home/chip/PocketInstaller/icon.png"
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
