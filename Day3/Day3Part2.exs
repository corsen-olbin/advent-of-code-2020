defmodule AOCDay3 do
  def find_product_of_trees_on_different_slopes(body, slopes) do
    body
    |> String.split("\r\n")
    |> count_trees_with_slopes(slopes)
    |> print_results()
  end

  defp count_trees_with_slopes(list, slopes) do
    Enum.map(slopes, fn {xslope, yslope} -> count_trees(xslope, yslope, list) end)
  end

  defp count_trees(xslope, yslope, list) do
    case yslope do
      1 -> count_trees_rec(0, xslope, list)
      2 -> count_trees_slope2_rec(1, xslope, tl(list))
    end
  end

  defp count_trees_rec(x, xslope, list) do
    case list do
      []            -> 0
      [head | tail] -> check_tree(x, head) + count_trees_rec(x + xslope, xslope, tail)
    end
  end

  defp count_trees_slope2_rec(x, xslope, list) do
    case list do
      []                   -> 0
      [_ | []]             -> 0
      [_, head2 | tail] -> check_tree(x, head2) + count_trees_slope2_rec(x + xslope, xslope, tail)
    end
  end

  defp check_tree(x, row) do
    case String.at(row, rem(x, String.length(row))) do
      "#" -> 1
      "." -> 0
    end
  end

  defp print_results(nums) do
    IO.puts("Product of trees on all slopes: #{Enum.reduce(nums, 1, fn x, acc -> x * acc end)}")
  end
end

case File.read("./Day3Values.txt") do
  {:ok, body}      -> AOCDay3.find_product_of_trees_on_different_slopes(body, [{1,1}, {3,1}, {5,1}, {7,1}, {1,2}])
  {:error, reason} -> IO.puts(reason)
end
