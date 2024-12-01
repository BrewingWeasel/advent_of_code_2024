import gleam/string

fn generic_parsing(input: String) {
  input
  |> string.trim_end()
  |> string.split("\n")
}

pub fn part1(input: String) -> String {
  let inp = generic_parsing(input)
  todo
}

pub fn part2(input: String) -> String {
  let inp = generic_parsing(input)
  todo
}
