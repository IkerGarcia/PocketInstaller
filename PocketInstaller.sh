#!/bin/bash

if hash zenity 2>/dev/null; then
  :
else
  sudo apt-get update
  sudo apt-get install -y zenity
fi
if hash yad 2>/dev/null; then
  :
else 
  echo "deb http://pkg.bunsenlabs.org/debian bunsen-hydrogen  main" | sudo tee -a /etc/apt/sources.list
  sudo apt-get update
  sudo apt-get install --yes --force-yes yad
fi

if hash mednafen 2>/dev/null; then
  :
else
  P1="Mednafen(GB,GBA,NES,SNES,NPC)|Installers/mednafen.sh"
fi

if hash x64 2>/dev/null; then
  :
else
  P2="Vice(C64,C128)|Installers/vice.sh"
fi

if hash prboom  2>/dev/null; then
  :
else
  P3="Doom|Installers/doom.sh"
fi

if hash openttd 2>/dev/null; then
  :
else 
  P4="OpenTTD|Installers/openttd.sh"
fi

if hash dosbox 2>/dev/null; then
  :
else 
  P5="DOSBox|Installers/dosbox.sh"
fi

if hash scummvm 2>/dev/null; then
  :
else
  P6="ScummVM|Installers/scummvm.sh"
fi
P7="PocketHome|Installers/PocketHome.sh"

menu=($P1 $P2 $P3 $P4 $P5 $P6 $P7)
  
yad_opts=(--form
--scroll
--text="Install Software"
--image="icon.png"
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
