#!/bin/bash

#####################################################################
### Please set your paths accordingly. In case you don't have all ###
### the listed folders, just keep the line commented out.         ###
#####################################################################
# Path to your config folder you want to backup
config_folder=~/klipper_config

# Path to your Klipper folder, by default that is '~/klipper'
#klipper_folder=~/klipper
klipper_folder=~/klipper

# Path to your Moonraker folder, by default that is '~/moonraker'
#moonraker_folder=~/moonraker
moonraker_folder=~/moonraker

# Path to your Mainsail folder, by default that is '~/mainsail'
#mainsail_folder=~/mainsail
mainsail_folder=~/mainsail

# Path to your Fluidd folder, by default that is '~/fluidd'
#fluidd_folder=~/fluidd
fluidd_folder=~/fluidd

#####################################################################
#####################################################################


######################################
### DO NOT EDIT BELOW THIS LINE!!! ###
######################################
grab_version(){
  if [ ! -z "$klipper_folder" ]; then
    cd "$klipper_folder"
    klipper_commit=$(git rev-parse --short=7 HEAD)
    m1="Klipper on commit: $klipper_commit"
    cd ..
  fi
  if [ ! -z "$moonraker_folder" ]; then
    cd "$moonraker_folder"
    moonraker_commit=$(git rev-parse --short=7 HEAD)
    m2="Moonraker on commit: $moonraker_commit"
    cd ..
  fi
  if [ ! -z "$mainsail_folder" ]; then
    mainsail_file=$(find $mainsail_folder/js -name "app.*.js" 2>/dev/null)
    mainsail_ver=$(grep -o -E 'state:{packageVersion:.+' $MAINSAIL_APP_FILE | cut -d'"' -f2)
    m3="Mainsail version: $mainsail_ver"
  fi
  if [ ! -z "$fluidd_folder" ]; then
    fluidd_file=$(find $fluidd_folder/js -name "app.*.js" 2>/dev/null)
    fluidd_ver=$(grep -o -E '"setVersion",".+"' $FLUIDD_APP_FILE | cut -d'"' -f4)
    m4="Fluidd version: $fluidd_ver"
  fi
}

push_config(){
  cd $config_folder
  git pull
  git add .
  current_date=$(date +"%Y-%m-%d %T")
  git commit -m "Autocommit from $current_date" -m "$m1" -m "$m2" -m "$m3" -m "$m4"
  git push
}

grab_version
push_config