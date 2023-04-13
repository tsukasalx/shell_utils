#!/bin/bash

function build_image {
    # Check if image exists, if not, build using docker-compose
    image_name=$1
    image_tag=$2
    image_name_with_tag=$image_name:$image_tag

    function find_image {
      ver=$(docker images | grep $image_name | awk '{print $2}' | grep $1)
      if [[ -z $ver ]]; then
        return 0
      else
        return 1
      fi
    }

    if find_image "$image_tag" -eq 0; then
      echo "$image_name_with_tag image not found. Building..."

      if [ $3 -eq 1 ]; then
        (cd $(dirname "$0")/../docker && docker-compose build --no-cache)
      elif [ $4 -eq 1 ]; then
        (cd $(dirname "$0")/../docker && docker-compose build)
      elif find_image "latest" -eq 0; then
        (cd $(dirname "$0")/../docker && docker-compose build)
      fi

      docker tag $image_name $image_name_with_tag
    fi

    # Verify if build is successful, if not, exit with error
    if find_image "$image_tag" -eq 0; then
      echo "Error: $image_name_with_tag build failed." >&2
      exit 1
    else
      echo "$image_name_with_tag build successfully."
    fi
}