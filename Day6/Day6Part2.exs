defmodule AOCDay6 do
  def find_sum_of_ubiquitous_answers_per_group(body) do
    body
    # split into groups
    |> String.split("\r\n\r\n")
    |> Enum.map(&calculate_ubiquitous_answers/1)
    |> Enum.sum
    |> print_results
  end

  def calculate_ubiquitous_answers(group) do
    group
    # split into people
    |> String.split("\r\n")
    |> Enum.map(&String.graphemes/1)
    |> find_ubiquitous_answers
    |> Enum.count
  end

  def find_ubiquitous_answers([head | []]), do: head

  def find_ubiquitous_answers([head | tail]) do
    Enum.reduce(tail, head, fn x, acc -> Enum.filter(acc, fn y -> Enum.member?(x, y) end) end)
  end

  defp print_results(sum), do: IO.puts("Sum of unique answer groups: #{sum}")

end

case File.read("./Day6Values.txt") do
  {:ok, body}      -> AOCDay6.find_sum_of_ubiquitous_answers_per_group(body)
  {:error, reason} -> IO.puts(reason)
end
