#!/bin/bash

check_root=$(git rev-parse --show-toplevel)

if [[ $# -ne 1 ]]; then
     echo "Error: Where arguments"
     echo "Usage: $0 <filename> "
     exit 1
fi


file_input="${check_root}/$1"

if [[ ! -f "$file_input" ]]; then
      echo "File DOESNT EXIST!!!"
      exit 1
fi
total_quant=$(wc -l < "${file_input}")
unic_quant=0 #колво уникальных файлов 
sha_quant=0 #колво изменений приводящих к изменению hahs-файла 
first_string=$(head -n 1 "$file_input" | cut -d ' ' -f1 )
prev_hash=""
#echo "$first_string"

while IFS= read -r line || [[ -n "$line" ]] ; do 
    first_word=$(echo "$line" | cut -d ' ' -f1)
   if [[ "$first_word" != "$first_string" ]]; then
        unic_quant=$((unic_quant+1))
   fi
   current_hash=$(echo "$line" | awk -F ' - ' '{print $4}')

   if [[  "$current_hash" != "$prev_hash" ]];then
          sha_quant=$((sha_quant+1))
   fi

   prev_hash="$current_hash"
done < "$file_input"
 

echo "$total_quant"  "$unic_quant" "$sha_quant"

echo "Done"