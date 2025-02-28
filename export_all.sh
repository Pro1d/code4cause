#!/bin/bash
#
# Install butler: https://itch.io/docs/butler/installing.html
#
# Run from project root
# $> bash ./build/export.sh

itch_project=hack-the-loop
itch_user=proyd
itch_upload=1

if [ ! -e project.godot ]; then
  echo Must be exected from root dir.
fi

build_and_push() {
  target=$1 # web ; windows ; linux ; quest ; android ; ...
  build_file=$2 # index.html ; $itch_project.exe ; $itch_project"_"$target.apk ; $itch_project.apk ; ...

  build_dir=build/$target
  build_path=$build_dir/$build_file
  mkdir -p $build_dir
  echo Godot export to $build_path
  godot4 --quiet --headless --export-release $target $build_path project.godot

  file_count=`ls -1 $build_dir | wc -l`
  if [ $file_count -gt 1 ]; then
    zip_path=build/$itch_project"_"$target.zip
    echo Zip to $zip_path
    rm $zip_path 2> /dev/null
    zip -j $zip_path $build_dir/* > /dev/null
    push_path=$zip_path
  else
    push_path=$build_path
  fi

  if [[ $itch_upload = 1 ]]; then
    echo Upload $push_path to itch $itch_project:$target
    butler push $push_path $itch_user/$itch_project:$target
  fi
}

build_and_push web index.html
build_and_push windows $itch_project.exe
build_and_push linux $itch_project.x86_64
#build_and_push quest $itch_project"_quest.apk"
#build_and_push pico $itch_project"_pico.apk"
#build_and_push lynx $itch_project"_lynx.apk"
#build_and_push khronos $itch_project"_khronos.apk"
#build_and_push android $itch_project.apk

echo "All done, visit:"
echo "https://${itch_user}.itch.io/${itch_project}"
