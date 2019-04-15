#!/bin/bash

videos=(./*.mkv ./*.mp4 ./*.webm)

result_audio=()

for CURRENT in "${videos[@]}"
do
  path=$(dirname -- "$CURRENT")
  file=$(basename -- "$CURRENT")
  extension="${file##*.}"
  filename="${file%.*}"

  # echo "$filename|${extension}"

  if [ "${extension}" == "mkv" ]; then
    audio_file="${filename}.opus"
  elif [ "${extension}" == "mp4" ]; then
    audio_file="${filename}.aac"
  elif [ "${extension}" == "webm" ]; then
    audio_file="${filename}.opus"
  else
    echo "Unknown: '${extension}'">&2
    exit 1
  fi
  # audio_file="${dirname}/${audio_filename}"

  if [ ! -e "${audio_file}" ]; then
    echo "ffmpeg -i ${file} -vn -acodec copy ${audio_file}"
    ffmpeg -i "${file}" -vn -acodec copy "${audio_file}"
    if [ ! $? -eq 0 ]; then
      rm "${audio_file}"
      echo "failed" >&2
      exit 2
    fi

    # Set the same modi&access time as the original
    touch --date=@$(stat -c %Y "${file}") "${audio_file}"

    # TODO add audio_file to list
    result_audio+=("${audio_file}")
  fi
done

# echo ""
# echo ""
# echo ""
# echo "ls -tr ${result_audio[@]}"
# echo ""
# echo ""
# echo ""
result_audio=(./*.opus)

savedIFS=$IFS   # Save current IFS
IFS=$'\n'
sorted_by_name=($(ls "${result_audio[@]}"))
sorted_by_date=($(ls -tr "${sorted_by_name[@]}"))
IFS=$savedIFS   # Restore IFS

#
for CURRENT in "${sorted_by_date[@]}"
do
  echo "${CURRENT}"
done

# # Get file times
# stat -c
#         %W     time of file birth, seconds since Epoch; 0 if unknown
#         %X     time of last access, seconds since Epoch
#         %Z     time of last status change, seconds since Epoch
#
#         %Y     time of last data modification, seconds since Epoch

# # Update the access and modification times 
# touch -t 


# ls - in order ASC
# ls -haltr *.opus
# ls -tr *opus
