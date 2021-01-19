#!/bin/sh

#Personal Setup for Openbox main script
#"setupob.sh"
#M. Yamanaka
#email: myamanaka@live.com
#website: csmyamanaka.com
#license: MIT (See included "LICENSE" file for details)

## Migrated from old repo

##
## Overhead
##

#openbox recognizes the following as its per-user config directory.
#It will hence forth be known as "OBROOT" in this script
OBROOT=$HOME/.config/openbox

#OBROOT is not created by default in most cases
mkdir -p $OBROOT

#also, a bunch of other directories will be made
mkdir -p $HOME/.local/media/images
mkdir -p $HOME/.local/scripts
#yes, we are using rofi today ladies and gentlemen
mkdir -p $HOME/.config/rofi

#copy rofi configs
cp $(pwd)/rofi/*.rasi $HOME/.config/rofi

#Openbox usually creates a global config directory /etc/xdg/openbox upon installation
#the global config files are copied to OBROOT to be modified
cp /etc/xdg/openbox/*.xml $OBROOT

##
## Keybindings
##

#retrieve the first and last line numbers of the keybindings portion in the original file

#### TODO: Make this more efficient!! find a better way than to do the grep | cut ... etc twice ####
KBBEGIN=$(grep -n "keyboard" $OBROOT/rc.xml | cut -f 1 -d ":" | head -n 1)
KBEND=$(grep -n "keyboard" $OBROOT/rc.xml | cut -f 1 -d ":" | tail -n 1)

#The script also needs to know the size of the original config file so that the "tail" command can
#print out the correct number of lines from the bottom
RCFILESZ=$(wc -l $OBROOT/rc.xml | awk '{print $1}')
CONFTAIL=$(( $RCFILESZ - $KBEND ))

CONFHEAD=$(( $KBBEGIN - 1 ))

#The overall strategy is to replace the keybindings section with the contents of my custom keybindings file
CUSTOMKEYS=$(pwd)/keybindings.xml

head -n $CONFHEAD $OBROOT/rc.xml > $OBROOT/tmpconf
cat $CUSTOMKEYS >> $OBROOT/tmpconf
tail -n $CONFTAIL $OBROOT/rc.xml >> $OBROOT/tmpconf

mv $OBROOT/tmpconf $OBROOT/rc.xml

##
## xinitrc
##

#replace the existing xinitrc (if any) with the one in this repo
mv $(pwd)/xinitrc $HOME/.xinitrc
