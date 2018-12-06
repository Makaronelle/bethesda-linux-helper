#!/usr/bin/env bash

# Little script to remove the current cdpprod.dch and rename
# the newly created cdpprod.dch.tmp to cdpprod.dch to workaround
# Bethesda.NET's current issue without any need for user action

# TODO: Stop the loop while Fallout 76 is launched cause we don't need to do anything there

LOOP_TIME=2 # How much do we wait in the loop before checking the files (in seconds)
EXE_NAME="BethesdaNetLauncher.exe" # Current now of Bethesda Launcher executable
TIMEOUT=60 # How much do we wait until we just think Bethesda won't launch at all ?
FILE="cdpprod.dch" # The infamous file we need to rename

launched=false # This script was launched, but is Bethesda Launcher launched ?
running=true # We will run until Bethesda Launcher stops running, or didn't run at all

# Animation stuff
frame=1
sp="/-\|"

printf "Waiting for Bethesda.Net launcher instance  "

while [[ $running == true ]]; do
   if [[ $launched == false ]]; then
      if [[ $(pgrep $EXE_NAME -f) ]]; then
         # It's running, everything is fine
         launched=true
         printf "\nFound running instance of Bethesda.Net launcher\n"
      else
         # We may need to wait ? Still, timeout incoming
         TIMEOUT=$((TIMEOUT-1))
         if [[ $TIMEOUT == 0 ]]; then
            running=false
            printf "\nFailed to find running instance of Bethesda.Net launcher\n"
         else
            printf "\b${sp:frame++%${#sp}:1}"
            sleep 1
         fi
      fi
   else
      # Here, we check if Bethesda is still running, and, obviously,
      # it's there that we do our m a g i c
      if [[ $(pgrep $EXE_NAME -f) ]]; then
         if [ -e "${FILE}.tmp" ]; then
            rm $FILE
            mv "${FILE}.tmp" $FILE
            echo "Renamed $FILE"
         fi
         sleep $LOOP_TIME
      else
         running=false
         echo "Bethesda.Net seemes to have closed, exiting"
      fi
   fi
done

