defmodule Day10 do
  def find_product_of_1_3_differences(body) do
    body
    |> String.split("\r\n")
    |> Enum.map(fn x -> String.to_integer(x) end)
    |> Enum.sort
    |> add_outlet_and_device
    |> create_diff_list
    |> multiply_num_of_1s_and_3s
    |> print_results
  end

  def add_outlet_and_device(list), do: [0 | list] ++ [Enum.max(list) + 3]

  def create_diff_list([head | list]) do
    create_diff_list_rec([], head, list)
  end

  def create_diff_list_rec(acc_list, _, []), do: acc_list

  def create_diff_list_rec(acc_list, head1, [head2 | list]) do
    create_diff_list_rec([head2 - head1 | acc_list], head2, list)
  end

  def multiply_num_of_1s_and_3s(list) do
    IO.puts(Enum.count(list))
    Enum.count(list, fn x -> x == 1 end) * Enum.count(list, fn x -> x == 3 end)
  end

  def print_results(num), do: IO.puts("Product of # of 1s and 3s: #{num}")
end


case File.read("./Day10Values.txt") do
  {:ok, body}      -> Day10.find_product_of_1_3_differences(body)
  {:error, reason} -> IO.puts(reason)
end
