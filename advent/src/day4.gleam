import gleam/dict
import gleam/int
import gleam/list
import gleam/string

fn generic_parsing(input: String) {
  input
  |> string.trim_end()
  |> string.split("\n")
  |> list.index_map(fn(line, row) {
    line
    |> string.split("")
    |> list.index_map(fn(char, col) { #(#(row, col), char) })
  })
  |> list.flatten()
  |> dict.from_list()
}

type Location =
  #(Int, Int)

fn can_match_locations(
  to_match: List(#(Location, String)),
  wordsearch: dict.Dict(Location, String),
) -> Bool {
  list.all(to_match, fn(matcher) {
    let #(location, char) = matcher
    case dict.get(wordsearch, location) {
      Ok(actual_char) if actual_char == char -> True
      _ -> False
    }
  })
}

fn generate_locations(
  x_diff: Int,
  y_diff: Int,
  start: Location,
  expected_chars: List(String),
) {
  list.index_map(expected_chars, fn(char, i) {
    #(#(start.0 + x_diff * { i + 1 }, start.1 + y_diff * { i + 1 }), char)
  })
}

pub fn part1(input: String) -> String {
  let wordsearch = generic_parsing(input)
  wordsearch
  |> dict.fold(from: 0, with: fn(acc, location, char) {
    case char {
      "X" -> {
        let locations = [
          #(1, -1),
          #(1, 0),
          #(1, 1),
          #(0, -1),
          #(0, 1),
          #(-1, -1),
          #(-1, 0),
          #(-1, 1),
        ]
        let total =
          list.count(locations, fn(x) {
            let loc = generate_locations(x.0, x.1, location, ["M", "A", "S"])
            can_match_locations(loc, wordsearch)
          })
        total + acc
      }
      _ -> acc
    }
  })
  |> int.to_string()
}

pub fn part2(input: String) -> String {
  let wordsearch = generic_parsing(input)
  wordsearch
  |> dict.fold(from: 0, with: fn(acc, location, char) {
    case char {
      "A" -> {
        let left_right_cross = #(#(location.0 + 1, location.1 + 1), #(
          location.0 - 1,
          location.1 - 1,
        ))
        let right_left_cross = #(#(location.0 - 1, location.1 + 1), #(
          location.0 + 1,
          location.1 - 1,
        ))

        case
          check_valid_cross_section(left_right_cross, wordsearch)
          && check_valid_cross_section(right_left_cross, wordsearch)
        {
          True -> acc + 1
          False -> acc
        }
      }
      _ -> acc
    }
  })
  |> int.to_string()
}

fn check_valid_cross_section(locs, wordsearch) {
  let #(top, bottom) = locs

  let valid_at_loc = fn(char) {
    case char {
      Ok("M") | Ok("S") -> True
      _ -> False
    }
  }
  let char_top = dict.get(wordsearch, top)
  let char_bottom = dict.get(wordsearch, bottom)
  valid_at_loc(char_top) && valid_at_loc(char_bottom) && char_top != char_bottom
}
