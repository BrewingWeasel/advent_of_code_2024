import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn parse(input: List(String)) -> List(Int) {
  list.map(input, fn(x) {
    let assert Ok(x) = int.parse(x)
    x
  })
}

fn generic_parsing(input: String) -> #(List(Int), List(Int)) {
  let assert Ok(lists) =
    input
    |> string.trim_end()
    |> string.split("\n")
    |> list.map(string.split_once(_, "   "))
    |> result.all()

  let #(left, right) = list.unzip(lists)
  #(parse(left), parse(right))
}

pub fn part1(input: String) -> String {
  let #(left, right) = generic_parsing(input)

  list.zip(list.sort(left, int.compare), list.sort(right, int.compare))
  |> list.fold(0, fn(acc, x) { acc + int.absolute_value(x.0 - x.1) })
  |> int.to_string()
}

pub fn part2(input: String) -> String {
  let #(left, right) = generic_parsing(input)

  left
  |> list.map(fn(x) {
    let count_in_right = list.count(right, fn(y) { x == y })
    count_in_right * x
  })
  |> int.sum()
  |> int.to_string()
}
