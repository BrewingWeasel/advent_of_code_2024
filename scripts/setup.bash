#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: ./scripts/setup.bash <day>"
  exit 1
fi

year=2024
day=$1
echo "Setting up Day $day"

echo "Getting example input..."

day_html="$(curl -s "https://adventofcode.com/$year/day/$day")"
sample_outfile="advent/input/day${day}_sample"
sample_contents="$(echo "$day_html" | sed -n '/<p>For example.*:<\/p>/,/<\/code><\/pre>/ { /<p>For example.*:<\/p>/d; s/<pre><code>//; /<\/code><\/pre>/d; p }')"

echo "found sample:"
echo "$sample_contents"
echo "$sample_contents" >"$sample_outfile"

curl -s "https://adventofcode.com/$year/day/$day/input" -H "cookie: session=$(cat secret)" >advent/input/day${day}

cp advent/src/dayn.gleam advent/src/day${day}.gleam

sample_value_day1="$(echo "$day_html" | rg -U "<code><em>.*</em></code>.*</p>\n<p>.*</p>\n</article>" | head -n 1 | sed "s/<p>.*<code><em>//; s/<\/em>.*<\/p>//")"

echo "updating advent.gleam"
sed -i "s/const current_day = .*/const current_day = $day/; \
   s/_ -> panic as \"Day not implemented\"/$day -> handle_day(current_day, day$day.part1, day$day.part2, expected_sample1: \"$sample_value_day1\", expected_sample2: \"\") \n    _ -> panic as \"Day not implemented\"/; \
   s/import gleam\/int/import day$day\nimport gleam\/int/" advent/src/advent.gleam
