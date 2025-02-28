#!/bin/bash
#
# Install butler: https://itch.io/docs/butler/installing.html

itch_project=test
itch_user=proyd
itch_upload=1


# WEB
godot4 --quiet --headless --export-release Web build/web/index.html ../project.godot
rm $itch_project"_"web.zip 2> /dev/null
zip -j $itch_project"_"web.zip web/* > /dev/null

if [[ $itch_upload = 1 ]]; then
  butler push $itch_project"_"web.zip $itch_user/$itch_project:web
fi

# WINDOWS
godot4 --quiet --headless --export-release Windows build/windows/$itch_project.exe ../project.godot
rm $itch_project"_"windows.zip 2> /dev/null
zip -j $itch_project"_"windows.zip windows/* > /dev/null

if [[ $itch_upload = 1 ]]; then
  butler push $itch_project"_"windows.zip $itch_user/$itch_project:windows
fi

# LINUX
godot4 --quiet --headless --export-release Linux build/linux/$itch_project.x86_64 ../project.godot
rm $itch_project"_"linux.zip 2> /dev/null
zip -j $itch_project"_"linux.zip linux/* > /dev/null

if [[ $itch_upload = 1 ]]; then
  butler push $itch_project"_"linux.zip $itch_user/$itch_project:linux
fi
