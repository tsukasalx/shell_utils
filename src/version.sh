#!/bin/bash

function check_update {
  REMOTE_ENV=$(wget -qO- "$1")

  for line in $REMOTE_ENV; do
    key=$(echo $line | cut -d '=' -f 1)
    value=$(echo $line | cut -d '=' -f 2)
    if [ "$key" == "MAJOR" ]; then
      REMOTE_MAJOR=$value
    fi
    if [ "$key" == "MINOR" ]; then
      REMOTE_MINOR=$value
    fi
    if [ "$key" == "PATCH" ]; then
      REMOTE_PATCH=$value
    fi
  done

  UPDATES_AVAILABLE=false
  if [[ $REMOTE_MAJOR > $MAJOR ]]; then
    UPDATES_AVAILABLE=true
  elif [[ $REMOTE_MINOR > $MINOR ]]; then
    UPDATES_AVAILABLE=true
  elif [[ $REMOTE_PATCH > $PATCH ]]; then
    UPDATES_AVAILABLE=true
  fi

  if $UPDATES_AVAILABLE; then
    echo "Current version: $2.$3.$4"
    echo "Latest version: $REMOTE_MAJOR.$REMOTE_MINOR.$REMOTE_PATCH"

    echo "A new version is available. Do you want to update? (y/n)"
    read answer
    while [ "$answer" != "y" ] && [ "$answer" != "n" ]; do
        echo "Invalid input, please enter y or n:"
        read answer
    done
    if [ "$answer" == "y" ]; then
      return 1
    else
      return 0
    fi
  fi
}
