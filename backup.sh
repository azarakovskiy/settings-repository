#!/bin/bash

PROJECTS_FOLDER=$1
[[ -z "${PROJECTS_FOLDER// }" ]] && echo "# Projects folder (1st param) should not be empty" && exit 1
[[ ! -d "${PROJECTS_FOLDER// }" ]] && echo "# You know, folder should be a folder" && exit 1
[[ ! "${PROJECTS_FOLDER// }" = /* ]] && [[ ! "${PROJECTS_FOLDER// }" = ~* ]] && echo "# Sorry, only absolute paths at the moment" && exit 1

OUTPUT_FOLDER=$2
[[ -z "${OUTPUT_FOLDER// }" ]] && echo "# Output folder (2nd param) should not be empty" && exit 1
[[ ! -d "${OUTPUT_FOLDER// }" ]] && mkdir $OUTPUT_FOLDER
[[ ! "${OUTPUT_FOLDER// }" = /* ]] && [[ ! "${OUTPUT_FOLDER// }" = ~* ]] && echo "# Sorry, only absolute paths at the moment" && exit 1

echo "# Doing stuff with folder $PROJECTS_FOLDER, with output to $OUTPUT_FOLDER"

cd $PROJECTS_FOLDER
inFolder=$(pwd)
echo "# Save the absolute path to a folder which is $inFolder"
echo "# Back to $(cd -)"

echo "# Remove $OUTPUT_FOLDER"
rm -r $OUTPUT_FOLDER


imlFiles=$(find $PROJECTS_FOLDER -name "*.iml" | sed "s~$inFolder/~~g" | tr " " "\n")

for file in $imlFiles
do
  #small trick for simplicity: nothing worked really 
  echo "# Create folder structure for $OUTPUT_FOLDER/$file"
  mkdir -p "$OUTPUT_FOLDER/$file"
  rmdir "$OUTPUT_FOLDER/$file"

  echo "# Copy $PROJECTS_FOLDER/$file to $OUTPUT_FOLDER/$file"
  cp "$PROJECTS_FOLDER/$file" "$OUTPUT_FOLDER/$file"
done

echo "# Copy $PROJECTS_FOLDER/FashionTrade/.idea folder to $OUTPUT_FOLDER/FashionTrade/.idea"
mkdir "$OUTPUT_FOLDER/FashionTrade/.idea"
cp -R "$PROJECTS_FOLDER/FashionTrade/.idea" "$OUTPUT_FOLDER/FashionTrade/.idea"

echo "# Commit and push to Git"
git pull
git add .
git commit -m "Projects settings auto backup `date`"
git push
