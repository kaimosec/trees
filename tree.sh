#!/bin/bash

# AUTHOR: KaimoSec (https://github.com/kaimosec) & ChatGPT
# VERSION: 1.0
# DESCRIPTION: Recursively lists files and directories (visible and hidden) up to a specified depth. Script will conspiciously list the directories it cannot read.
# EXAMPLES:
# 	Tree from /home, recursing infinitely
# 	./tree.sh /home 0
#
# 	Tree from /home, with a depth of 2 (current dir/files and subdir/subfiles)
# 	./tree.sh /home 2

# List all files in directory, indenting as specified
function list_files() {
    local dir=$1
    local depthstr=$2


    for file in "$dir/"* "$dir/".*; do
	if [[ -f "$file" ]]; then
            echo "${depthstr} ${file##*/}"
	fi
    done
}

# Function to recursively list directories with indentation
function list_directories() {
    local dir=$1
    local depth=$2
    local maxdepth=$3


    # Get indent strings
    local baseindent=""
    for ((i=0;i<depth-1;i++)); do
        baseindent+="| "
    done
    local dirindent="$baseindent--"
    local fileindent="$baseindent| "


    echo "${dirindent}$dir/"


    # Return if it has recursed enough
    if [[ $maxdepth > 0 ]] && [[ $depth -ge $maxdepth ]]; then
	    return
    fi

    # Check if can access directory
    if [[ ! -r "$dir" ]]; then
        echo "${fileindent} ACCESS DENIED"
	return
    fi

    # Check if directory is a symlink
    if [[ -h "$dir" ]]; then
	echo "${fileindent} IGNORING SYMLINK"
	return
    fi

    list_files "$dir" "$fileindent"

    for file in "$dir/"* "$dir/".*; do
        if [[ -d "$file" ]]; then
		local bname=$(basename "$file")
	    if [[ "$bname" != ".." ]] && [[ "$bname" != "." ]]; then
                list_directories "$file" "$((depth+1))" $maxdepth
	    fi
	fi
    done
}

list_directories "$1" 0 $2

