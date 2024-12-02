import gleam/bool
import gleam/int
import gleam/list
import gleam/string

fn generic_parsing(input: String) {
  input
  |> string.trim_end()
  |> string.split("\n")
  |> list.map(fn(line) {
    line
    |> string.split(" ")
    |> list.map(fn(level) {
      let assert Ok(level) = int.parse(level)
      level
    })
  })
}

fn report_valid(level: List(Int)) -> Bool {
  let sorted = list.sort(level, int.compare)
  let is_valid_sorted = {
    sorted == level || list.reverse(level) == sorted
  }

  let has_correct_increases =
    list.window_by_2(sorted)
    |> list.any(fn(x) {
      let difference = int.absolute_value(x.1 - x.0)
      difference >= 4 || difference < 1
    })
    |> bool.negate()

  is_valid_sorted && has_correct_increases
}

pub fn part1(input: String) -> String {
  let inp = generic_parsing(input)
  list.count(inp, fn(level) { report_valid(level) })
  |> int.to_string()
}

fn use_problem_dampener(input: List(Int), left: List(Int), right: List(Int)) {
  use <- bool.guard(report_valid(input), True)

  case right {
    [next, ..rest] ->
      use_problem_dampener(
        list.append(left, rest),
        list.append(left, [next]),
        rest,
      )
    [] -> False
  }
}

pub fn part2(input: String) -> String {
  let inp = generic_parsing(input)
  list.count(inp, fn(x) { use_problem_dampener(x, [], x) })
  |> int.to_string()
}
