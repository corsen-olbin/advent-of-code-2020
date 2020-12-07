defmodule AOCDay3 do
  def find_num_of_trees(body) do
    body
    |> String.split("\r\n")
    |> count_trees()
    |> print_results()
  end

  defp count_trees(list) do
    count_trees_rec(0, list)
  end

  defp count_trees_rec(x, list) do
    case list do
      []            -> 0
      [head | tail] -> check_tree(x, head) + count_trees_rec(x + 3, tail)
    end
  end

  defp check_tree(x, row) do
    case String.at(row, rem(x, String.length(row))) do
      "#" -> 1
      "." -> 0
    end
  end

  defp print_results(num) do
    IO.puts("Number of Trees: #{num}")
  end
end

case File.read("./Day3Values.txt") do
  {:ok, body}      -> AOCDay3.find_num_of_trees(body)
  {:error, reason} -> IO.puts(reason)
end
