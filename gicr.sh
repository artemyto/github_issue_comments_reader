#!/bin/bash

while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -u|--user)
        USER="$2"
        shift # past argument
        shift # past value
        ;;
        -r|--repo)
        REPO="$2"
        shift # past argument
        shift # past value
        ;;
        -i|--issue)
        ISSUE="$2"
        shift # past argument
        shift # past value
        ;;
        -s|--since)
        SINCE="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        shift # past argument
        ;;
    esac
done

NUMBER=1

RESP=$(curl -s "https://api.github.com/repos/$USER/$REPO/issues/$ISSUE/comments?per_page=100&since=$SINCE&page=$NUMBER" | grep -e login -e created_at -e body | sed 's#"login"#\n"login"#g' | sed 's#\\r\\n#\n\t\t#g')

while [[ $RESP != "" ]]; do

    echo "${RESP}"

    ((++NUMBER))

    RESP=$(curl -s "https://api.github.com/repos/$USER/$REPO/issues/$ISSUE/comments?per_page=100&since=$SINCE&page=$NUMBER" | grep -e login -e created_at -e body | sed 's#"login"#\n"login"#g' | sed 's#\\r\\n#\n\t\t#g')

done
