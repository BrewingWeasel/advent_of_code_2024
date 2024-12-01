#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: ./scripts/setup.bash <day>"
  exit 1
fi

year=2024
day=$1
echo "Setting up Day $day"

echo "Getting example input..."

sample_outfile="advent/input/day${day}_sample"
sample_contents="$(curl -s "https://adventofcode.com/$year/day/$day" | sed -n '/<p>For example.*:<\/p>/,/<\/code><\/pre>/ { /<p>For example.*:<\/p>/d; s/<pre><code>//; /<\/code><\/pre>/d; p }')"
echo "found sample:"
echo "$sample_contents"
echo "$sample_contents" >"$sample_outfile"

curl -s "https://adventofcode.com/$year/day/$day/input" -H "cookie: session=$(cat secret)" >advent/input/day${day}

cp advent/src/dayn.gleam advent/src/day${day}.gleam

echo "updating advent.gleam"
sed -i "s/const current_day = .*/const current_day = $day/; \
   s/_ -> panic as \"Day not implemented\"/$day -> handle_day(current_day, day$day.part1, day$day.part2, expected_sample1: \"\", expected_sample2: \"\") \n    _ -> panic as \"Day not implemented\"/; \
   s/import gleam\/int/import day$day\nimport gleam\/int/" advent/src/advent.gleam
