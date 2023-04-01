#!/bin/bash

default_yes=0
while getopts ":y" opt; do
  case ${opt} in
    y )
      default_yes=1
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

alias_name=$1
cmd=${*:2}
existing_alias=$(grep -o "^alias $alias_name=.*" ~/.bashrc)

if [[ -n $existing_alias ]]; then
  if [[ $default_yes -eq 0 ]]; then
    read -p "The alias '$alias_name' already exists. Do you want to replace it with '$cmd'? [Y/n] " replace_alias
    case ${replace_alias} in
        [Yy] )
        ;;
        * )
        exit 0
        ;;
    esac
  fi
  sed -i "s|^alias $alias_name=.*|alias $alias_name='$cmd'|" ~/.bashrc
else
  echo "alias $alias_name='$cmd'" >> ~/.bashrc
fi

eval "alias $alias_name='$cmd'"

echo "The alias '$alias_name' has been added successfully."
