#!/bin/bash
readonly DEPLOY_DIR="$1"
readonly BUILD_ARCHIVE="$2"
readonly APP_VERSIONED_INSTALL_DIR="$3"

function get-tar-roots {
    # Gets all the root entries of the tar file contents
    local file="$1"
    tar tzf "$file" \
        | awk -F/ '{print $1}' \
        | sort \
        | uniq
}

function is-friendly-tar {
    # Tar is friendly if it contains a single subdirectory
    local roots="$1"
    local num_root=$(echo "$roots" \
        | wc -l)
    [[ "$num_root" -eq 1 ]]
}

function is-directory {
    local f="$1"
    [[ -d "$f" ]]
}

function make-shallow {
    # Copies all contents from input subdirs into the basedir and then
    # removes the subdir
    local roots="$1"
    local basedir="$2"
    local fulldir=""
    for subdir in "$roots"; do
        fulldir="$basedir"/"$subdir"
        echo "Making directory shallower: $fulldir"
        is-directory "$fulldir" \
            && cp -Rf "$fulldir"/* "$basedir" \
            && rm -rf "$fulldir"
    done
}

function main {
    local basedir="$APP_VERSIONED_INSTALL_DIR"
    local roots=$(get-tar-roots "$DEPLOY_DIR"/"$BUILD_ARCHIVE")
    is-friendly-tar "$roots" \
        && make-shallow "$roots" "$basedir" \
        || exit 0
}

main
