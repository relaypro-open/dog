#!/bin/bash
readonly BUILD_USER="$1"
readonly BUILD_TOKEN="$2"
readonly BUILD_SERVER="$3"
readonly APP="$4"
readonly TYPE="$5"

function s3-timestamp {
    local proto="https"
    local host="$BUILD_SERVER"
    local path="/job/"$APP"/lastSuccessfulBuild/buildTimestamp"
    local query="format=yyyy-MM-dd_HH-mm-ss"
    local cred=""$BUILD_USER":"$BUILD_TOKEN""
    curl -su "$cred" "$proto"://"$host""$path"?"$query"
}

function s3-version {
    local proto="https"
    local host="$BUILD_SERVER"
    local path="/job/"$APP"/lastSuccessfulBuild/api/xml"
    local query="xpath=(/*/artifact)\[1\]/fileName"
    local cred=""$BUILD_USER":"$BUILD_TOKEN""
    # Includes hack to parse single XML element since the /text() xpath
    # doesn't work in Jenkins.
    curl -su "$cred" "$proto"://"$host""$path"?"$query" \
        | sed -n -e 's/.*<fileName>\(.*\)<\/fileName>.*/\1/p' \
        | awk -F"$APP""-" '{print $2}' \
        | sed -e 's/.tar.gz$//' \
        | xargs echo -n
}

function main {
    case "$TYPE" in
        "timestamp") s3-timestamp
            ;;
        "version") s3-version
            ;;
        *) exit 1
            ;;
    esac
}

main
