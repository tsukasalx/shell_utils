#!/bin/bash

function check_update {
  REMOTE_ENV=$(wget -qO- "$1")
  if [ $? -ne 0 ]; then
    echo "Request the lastest version info failed" >&2
    echo 0
    echo 0
    echo 0
    echo $2
    echo $3
    echo $4
  else
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
    if [[ $REMOTE_MAJOR > $2 ]]; then
      UPDATES_AVAILABLE=true
      echo 1
    else
      echo 0
    fi
    if [[ $REMOTE_MINOR > $3 ]]; then
      UPDATES_AVAILABLE=true
      echo 1
    else
      echo 0
    fi
    if [[ $REMOTE_PATCH > $4 ]]; then
      UPDATES_AVAILABLE=true
      echo 1
    else
      echo 0
    fi

    if $UPDATES_AVAILABLE; then
      echo "Current version: $2.$3.$4" >&2
      echo "Latest version: $REMOTE_MAJOR.$REMOTE_MINOR.$REMOTE_PATCH" >&2

      echo "A new version is available. Do you want to update? (y/n)" >&2
      read answer
      while [ "$answer" != "y" ] && [ "$answer" != "n" ]; do
          echo "Invalid input, please enter y or n:" >&2
          read answer
      done
      if [ "$answer" == "y" ]; then
        echo $REMOTE_MAJOR
        echo $REMOTE_MINOR
        echo $REMOTE_PATCH
        return 1
      else
        echo $2
        echo $3
        echo $4
        return 0
      fi
    else
      echo $2
      echo $3
      echo $4
      return 0
    fi
  fi
}
