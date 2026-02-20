#!/bin/bash 
check_root=$(git rev-parse --show-toplevel)

if [[ $# -ne 4 ]]; then
     echo "Error: Where arguments"
     echo "Usage: $0 <filename> <line_number> <old_string> <new_string>"
     exit 1
fi

file_input="${check_root}/$1"
line_number=$2
old_string=$3
change=$4

if [[ ! -f "$file_input" ]]; then
      echo "File DOESNT EXIST!!!"
      exit 1
fi

line_exist=$(sed -n "${line_number}p" "${file_input}" | grep -o "${old_string}")
sed -i "" "${line_number}s/${old_string}/${change}/" "${file_input}"
if [[ -z "$line_exist" ]];then
    echo "String DOESNT EXIST"
fi

if [[ "$line_number" -le 0 ]];then 
     echo "Negative string dont exist"
     exit 1
fi

output_file="${check_root}/src/files.log"

input_size=$(stat -f "%z" "$file_input")
input_date=$(date -r "$file_input" "+%Y-%m-%d %H:%M")
sha_input=$(shasum -a 256 "$file_input" | awk '{print $1}')

write_to_file="$1 - $input_size - $input_date - $sha_input - sha256"

if  echo "$write_to_file" >> "$output_file";then
     echo "Done"
else
     echo  "Write failed"
     exit 1 
fi
exit 0


