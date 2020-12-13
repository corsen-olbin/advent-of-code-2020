defmodule Day10 do
  def find_how_many_combos(body) do
    body
    |> String.split("\r\n")
    |> Enum.map(fn x -> String.to_integer(x) end)
    |> Enum.sort
    |> add_outlet_and_device
    |> create_diff_list
    |> get_list_of_continuous_1_counts
    |> Enum.reduce(1, fn x, acc -> acc * num_of_combos(x) end)
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

  def get_list_of_continuous_1_counts(list), do: get_list_of_continuous_1_counts_rec([], 0, list)

  def get_list_of_continuous_1_counts_rec(acc_list, 0, []), do: acc_list
  def get_list_of_continuous_1_counts_rec(acc_list, acc, []), do: [acc | acc_list]

  def get_list_of_continuous_1_counts_rec(acc_list, current_acc, [1 | list]) do
    get_list_of_continuous_1_counts_rec(acc_list, current_acc + 1, list)
  end

  def get_list_of_continuous_1_counts_rec(acc_list, 0, [3 | list]) do
    get_list_of_continuous_1_counts_rec(acc_list, 0, list)
  end

  def get_list_of_continuous_1_counts_rec(acc_list, current_acc, [3 | list]) do
    get_list_of_continuous_1_counts_rec([current_acc | acc_list], 0, list)
  end

  def multiply_num_of_1s_and_3s(list) do
    IO.puts(Enum.count(list))
    Enum.count(list, fn x -> x == 1 end) * Enum.count(list, fn x -> x == 3 end)
  end

  def num_of_combos(num_of_1s) do
    case num_of_1s do
      1 -> 1
      2 -> 2
      3 -> 4
      4 -> 7
    end
  end

  def print_results(num), do: IO.puts("Num of possible combos: #{num}")
end


case File.read("./Day10Values.txt") do
  {:ok, body}      -> Day10.find_how_many_combos(body)
  {:error, reason} -> IO.puts(reason)
end
