defmodule AOCDay6 do
  def find_sum_of_unique_question_groups(body) do
    body
    |> String.split("\r\n\r\n")
    |> Enum.map(&(calculate_unique_answers(&1)))
    |> Enum.sum()
    |> print_results()
  end

  def calculate_unique_answers(group) do
    group
    |> String.replace("\r\n", "")
    |> String.graphemes
    |> Enum.uniq
    |> Enum.count
  end

  defp print_results(sum), do: IO.puts("Sum of unique answer groups: #{sum}")

end

case File.read("./Day6Values.txt") do
  {:ok, body}      -> AOCDay6.find_sum_of_unique_question_groups(body)
  {:error, reason} -> IO.puts(reason)
end
