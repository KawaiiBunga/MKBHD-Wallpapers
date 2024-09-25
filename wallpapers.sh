#!/bin/bash

curl -s https://storage.googleapis.com/panels-api/data/20240916/media-1a-i-p~s | jq -r '.data | to_entries[] | "\(.key) \(.value)"' | while read -r id data; do
  mkdir -p "images/$id"
  echo "$data" | jq -r 'to_entries[] | "\(.key) \(.value)"' | while read -r key url; do
    if [[ "$url" =~ ^https?:// ]]; then
      curl -s -o "images/$id/$key.jpg" "$url" &
    fi
  done
done

wait