import day1
import gleam/int
import gleam/io
import gleam_community/ansi
import simplifile

const current_day = 1

pub fn main() {
  case current_day {
    1 -> handle_day(1, day1.part1, day1.part2, sample: False)
    _ -> panic as "Day not implemented"
  }
}

fn handle_day(
  day: Int,
  first: fn(String) -> Int,
  second: fn(String) -> Int,
  sample sample: Bool,
) {
  let assert Ok(inp) =
    simplifile.read(
      "input/day"
      <> int.to_string(day)
      <> case sample {
        True -> "_sample"
        False -> ""
      },
    )

  io.println("\u{001b}[2J;\u{001b}[1;1H")

  io.println(ansi.bold(ansi.blue("Day " <> int.to_string(day)) <> ":") <> "\n")

  io.println(ansi.bold(ansi.pink("Part 1: ")) <> int.to_string(first(inp)))
  io.println(
    "------------------------------------------------------------------------",
  )
  io.println(ansi.bold(ansi.pink("Part 2: ")) <> int.to_string(second(inp)))
  io.println(
    "------------------------------------------------------------------------",
  )
}
