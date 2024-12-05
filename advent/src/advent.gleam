import day1
import day2
import day3
import day4
import gleam/int
import gleam/io
import gleam_community/ansi
import simplifile

const current_day = 4

pub fn main() {
  case current_day {
    1 ->
      handle_day(
        1,
        day1.part1,
        day1.part2,
        expected_sample1: "11",
        expected_sample2: "31",
      )
    2 ->
      handle_day(
        current_day,
        day2.part1,
        day2.part2,
        expected_sample1: "2",
        expected_sample2: "4",
      )
    3 ->
      handle_day(
        current_day,
        day3.part1,
        day3.part2,
        expected_sample1: "161",
        expected_sample2: "",
      )
    4 ->
      handle_day(
        current_day,
        day4.part1,
        day4.part2,
        expected_sample1: "18",
        expected_sample2: "9",
      )
    _ -> panic as "Day not implemented"
  }
}

fn handle_day(
  day: Int,
  part1 part1: fn(String) -> String,
  expected_sample1 sample_answer1: String,
  part2 part2: fn(String) -> String,
  expected_sample2 sample_answer2: String,
) {
  let assert Ok(full_inp) = simplifile.read("input/day" <> int.to_string(day))
  let assert Ok(sample_inp) =
    simplifile.read("input/day" <> int.to_string(day) <> "_sample")

  io.println("\u{001b}[2J;\u{001b}[1;1H")

  io.println(ansi.bold(ansi.blue("Day " <> int.to_string(day)) <> ":") <> "\n")

  io.println(
    "------------------------------------------------------------------------",
  )
  io.println(ansi.bold(ansi.pink("Part 1: ")))
  display_part(part1, sample_answer1, sample_inp:, full_inp:)

  io.println(
    "------------------------------------------------------------------------",
  )
  io.println(ansi.bold(ansi.pink("Part 2: ")))
  display_part(part2, sample_answer2, sample_inp:, full_inp:)
}

fn display_part(
  handler: fn(String) -> String,
  sample_answer sample_answer: String,
  sample_inp sample_inp: String,
  full_inp full_inp: String,
) {
  let attempted_solved_sample = handler(sample_inp)
  let styled_sample = case sample_answer == attempted_solved_sample {
    True -> ansi.green(attempted_solved_sample <> ansi.bold(" (Correct)"))
    False ->
      ansi.red(
        attempted_solved_sample
        <> ansi.bold(" (Expected " <> sample_answer <> ")"),
      )
  }
  io.println(ansi.bold(ansi.cyan("Sample input: ")) <> styled_sample)
  io.println(ansi.bold(ansi.blue("Full input: ")) <> handler(full_inp) <> "\n")
}
