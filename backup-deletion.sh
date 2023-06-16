#!/bin/bash

 

data_directory="/data"
max_disk_usage_percentage=90
days_to_keep=10

 

check_disk_space() {
    disk_usage=$(df -P "$1" | awk 'NR==2 {print $5}' | tr -d '%')
    echo "$disk_usage"
}

 

delete_old_files() {
    directory="$1"
    days="$2"
    current_time=$(date +%s)
    oldest_allowed_time=$(date -d "-$days days" +%s)

 

    find "$directory" -type f -mtime +"$days" -print0 | while IFS= read -r -d '' file; do
        file_modified_time=$(stat -c %Y "$file")
        if (( file_modified_time < oldest_allowed_time )); then
            rm "$file"
            echo "Deleted file: $file"
        fi
    done
}

 

disk_usage=$(check_disk_space "$data_directory")

 

if (( disk_usage > max_disk_usage_percentage )); then
    echo "Disk usage is $disk_usage%. Deleting old files..."
    delete_old_files "$data_directory" "$days_to_keep"
else
    echo "Disk usage is $disk_usage%. No action required."
fi
