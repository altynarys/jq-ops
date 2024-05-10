#!/bin/bash

while getopts o:n:d: flag
do
    case "${flag}" in
        o) oldenv=${OPTARG};;
        n) newenv=${OPTARG};;
        d) daystamp=${OPTARG};;
    esac
done

echo "Current environment: $oldenv";
echo "New environment: $newenv";
echo "Day: $daystamp";
echo "\n\nInput:"
jq '.' input.json

echo "\nOutput:"
jq --arg oldenv $oldenv --arg newenv $newenv --arg daystamp $daystamp -r '
   map(select(.page.endpoint | test(".*-" + $oldenv + "-[a-z]+-[0-9]{8}.html")) | 
              .page.endpoint |= sub($oldenv; $newenv) | 
              .page.endpoint |= sub("[0-9]{8}.html"; $daystamp + ".html")
      )' \
   input.json

