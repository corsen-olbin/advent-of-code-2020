defmodule Day8 do

  def find_acc_value_of_first_repeat_line(body) do
    body
    |> IntCodeReader.parse
    |> run_code_until_repeat_line
    |> print_results
  end

  def run_code_until_repeat_line(code) do
    run_code_until_repeat_line_rec(code, 0, 0, [])
  end

  def run_code_until_repeat_line_rec(code, line_num, acc, line_list) do
    case Enum.member?(line_list, line_num) do
      true -> acc
      false -> run_next_line(code, line_num, acc, line_list)
    end
  end

  def run_next_line(code, line_num, acc, line_list) do
    {new_acc, new_line_num} = IntCodeReader.execute_line(code, line_num, acc)
    run_code_until_repeat_line_rec(code, new_line_num, new_acc, [line_num | line_list])
  end

  def print_results(num), do: IO.puts("Accumulator before program runs a line for the 2nd time: #{num}")

end

defmodule IntCodeReader do

  def parse(code_string) do
    code_string
    |> String.split("\r\n")
    |> Enum.with_index(1)
    |> Enum.map(fn {line, line_num} -> parse_line(line, line_num) end)
  end

  def parse_line(line, line_num) do
    capture = Regex.named_captures(~r/(?<command>[a-z]+) (?<value>[+-][0-9]+)/, line)
    %{ line_num: line_num, command: capture["command"], value: String.to_integer(capture["value"]) }
  end

  def execute_line(code, line_num, acc) do
    case Enum.at(code, line_num) do
      %{command: "acc", line_num: _, value: x} -> { acc + x, line_num + 1 }
      %{command: "jmp", line_num: _, value: x} -> { acc    , line_num + x }
      %{command: "nop", line_num: _, value: _} -> { acc    , line_num + 1 }
    end
  end

end

case File.read("./Day8Values.txt") do
  {:ok, body}      -> Day8.find_acc_value_of_first_repeat_line(body)
  {:error, reason} -> IO.puts(reason)
end
