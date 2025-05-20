#!/usr/bin/env bash

PLIST=~/Library/Preferences/com.apple.finder.plist
ITEMS=`/usr/libexec/PlistBuddy -c "Print 'NSToolbar Configuration Browser:TB Default Item Identifiers'" $PLIST | sed '1d; $d'`
POSITION=1  # Cambia esto si deseas que TRSH esté en otra posición

# Eliminar configuraciones anteriores
/usr/libexec/PlistBuddy -c "Delete 'NSToolbar Configuration Browser:TB Item Identifiers'" $PLIST 2>/dev/null
/usr/libexec/PlistBuddy -c "Delete 'NSToolbar Configuration Browser:TB Item Plists'" $PLIST 2>/dev/null

# Agregar nuevos identificadores
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser:TB Item Identifiers' array" $PLIST
i=1
for ITEM in $ITEMS
do
  if [ $i -ne $POSITION ]; then
    /usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser:TB Item Identifiers:$i' string $ITEM" $PLIST
  fi
  ((i++))
done

# Agregar la papelera (TRSH) en la posición deseada
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser:TB Item Identifiers:$POSITION' string 'com.apple.finder.TRSH'" $PLIST

# Reiniciar Finder
killall -HUP Finder

