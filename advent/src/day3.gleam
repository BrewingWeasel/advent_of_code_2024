import gleam/int
import gleam/list
import gleam/string

type Instruction {
  Multiply(Int, Int)
  Do
  Dont
}

fn generic_parsing(input: String) -> List(Instruction) {
  generic_parsing_loop(input, [])
}

fn parse_number(
  input: String,
  end_char: String,
  instructions: List(Instruction),
  callback: fn(Int, String) -> List(Instruction),
) -> List(Instruction) {
  case string.split_once(input, end_char) {
    Ok(#(possible_number, rest)) ->
      case int.parse(possible_number) {
        Ok(number) -> {
          callback(number, rest)
        }
        Error(_) -> generic_parsing_loop(input, instructions)
      }
    Error(Nil) -> generic_parsing_loop(input, instructions)
  }
}

fn generic_parsing_loop(
  input: String,
  instructions: List(Instruction),
) -> List(Instruction) {
  case input {
    "mul(" <> rest -> {
      use first, rest <- parse_number(rest, ",", instructions)
      use second, rest <- parse_number(rest, ")", instructions)
      generic_parsing_loop(rest, [Multiply(first, second), ..instructions])
    }
    "do()" <> rest -> generic_parsing_loop(rest, [Do, ..instructions])
    "don't()" <> rest -> generic_parsing_loop(rest, [Dont, ..instructions])
    "" -> instructions
    _ -> generic_parsing_loop(string.drop_start(input, 1), instructions)
  }
}

pub fn part1(input: String) -> String {
  generic_parsing(input)
  |> list.fold(0, fn(acc, x) {
    case x {
      Multiply(a, b) -> acc + a * b
      _ -> acc
    }
  })
  |> int.to_string()
}

pub fn part2(input: String) -> String {
  let #(added, _in_dont) =
    generic_parsing(input)
    |> list.reverse()
    |> list.fold(#(0, True), fn(acc, x) {
      let #(added, run) = acc
      case x {
        Multiply(a, b) if run -> #(added + a * b, run)
        Multiply(_, _) -> #(added, run)
        Dont -> #(added, False)
        Do -> #(added, True)
      }
    })

  int.to_string(added)
}
