#!/bin/bash

# Get a random image
IMAGE_DIR=~/Pictures/wallpaper

IMAGE=$(ls $IMAGE_DIR | shuf -n 1)
wallpaper() {
    ~/.config/i3/change-wallpaper.sh "$1"
}
# Use the function with the random image
wallpaper "$IMAGE"
