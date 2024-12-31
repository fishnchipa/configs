#!/bin/bash

PROFILE_ID=$(gsettings get org.gnome.Terminal.ProfilesList list | grep -o "'[^']*'" | sed "s/'//g" | head -n 1)

IMAGE="$1"
RED='\033[1;31m' 
GREEN='\033[1;32m' 

# Ensure the directory exists
IMAGE_DIR=~/Pictures/wallpaper
if [ ! -d "$IMAGE_DIR" ]; then
    echo "${RED}Image directory does not exist: $IMAGE_DIR"
    exit 1
fi

if [ "$#" -eq 0 ]; then
    echo -e "${RED}No wallpaper provided"
    exit 1
fi 

if [ "$#" -gt 1 ]; then 
    echo -e "${RED}Invalid number of wallpaper"
    exit 1
fi

if [ "$1" == "--help" ]; then 
    for FILE in "$IMAGE_DIR"/*; do 
        filename=$(echo "$FILE" | cut -d"." -f1 | cut -d"/" -f6)
        echo -e "${GREEN} - $filename"
    done
    echo -e "${GREEN} - blank"
    exit 0
fi 

if [ "$1" == "blank" ]; then
    TRANSPARENCY=0
    echo "Setting Wallpaper to: Blank"
    dconf write /org/gnome/terminal/legacy/profiles:/:${PROFILE_ID}/background-transparency-percent $(echo "$TRANSPARENCY" | bc)
    exit 0
fi

for FILE in "$IMAGE_DIR"/*; do 
    name=$(echo "$FILE" | grep -E "$IMAGE" | cut -d"/" -f6)
    if [ ! -z "$name" ]; then 
        break 
    fi 
done 

if [ -z "$name" ]; then 
    echo -e "${RED}Invalid wallpaper: $name"
    exit 1
fi

# Set the background using feh
fname=$(echo "$name" | cut -d"." -f1)
feh --bg-scale $IMAGE_DIR/${name}
echo "Setting Wallpaper to: $fname"


# Conditional output based on the image selected
case "$name" in
    "fate1.jpg")
        TRANSPARENCY=20
        ;;
    "fate2.jpg")
        TRANSPARENCY=15
        ;;
    "abyss1.jpg")
        TRANSPARENCY=10
        ;;
    "abyss2.jpg")
        TRANSPARENCY=20
        ;;
    "frieren1.jpeg")
        TRANSPARENCY=10
        ;;
    "nier1.jpg")
        TRANSPARENCY=20
        ;;
    "scfi1.jpg")
        TRANSPARENCY=20
        ;;
    "environment1.jpeg")
        TRANSPARENCY=10
        ;;
    *)
        TRANSPARENCY=10
        ;;
esac

# Set terminal transparency
dconf write /org/gnome/terminal/legacy/profiles:/:${PROFILE_ID}/background-transparency-percent $(echo "$TRANSPARENCY" | bc)
