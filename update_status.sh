#!/bin/bash

# Check if all arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <job_names_file> <job_status_file> <output_file>"
    exit 1
fi

job_names_file="$1"
job_status_file="$2"
output_file="$3"

# Check if both files exist
if [ ! -f "$job_names_file" ] || [ ! -f "$job_status_file" ]; then
    echo "One or both of the files do not exist."
    exit 1
fi

# Process each job name from the job names file
while IFS= read -r job_name; do
    # Search for the job name in the status file
    job_status=$(grep "^$job_name " "$job_status_file" | awk '{print $2}')

    # Determine the status to be written in the output file
    case $job_status in
        "SU")
            status="SUCCESS"
            ;;
        "IO")
            status="ON_ICE"
            ;;
        "TE")
            status="TERMINATED"
            ;;
        *)
            status="UNKNOWN"
            ;;
    esac

    # Write the job name and status to the output file
    echo "$job_name $status" >> "$output_file"
done < "$job_names_file"

echo "Job names and statuses updated in $output_file."