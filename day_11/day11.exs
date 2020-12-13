defmodule Day11 do

  def find_num_of_seats_after_no_changes(body) do
    body
    |> String.split("\r\n")
    |> Matrix.build_matrix
    |> IO.inspect
  end

  def calculate_next_state(seat_map) do
    calculate_next_state_rec(current_map, current_map, )
  end


end

defmodule Matrix do
  def build_matrix(string_list), do: build_matrix_rec(%{}, 0, string_list)

  defp build_matrix_rec(acc_map, _, []), do: acc_map
  defp build_matrix_rec(acc_map, index, [head | string_list]), do: build_matrix_rec(Map.put_new(acc_map, index, build_inner_map(String.graphemes(head))), index + 1, string_list)

  defp build_inner_map(string_list), do: build_inner_map_rec(%{}, 0, string_list)

  defp build_inner_map_rec(acc_map, _, []), do: acc_map
  defp build_inner_map_rec(acc_map, index, [head | string_list]), do: build_inner_map_rec(Map.put_new(acc_map, index, head), index + 1, string_list)
end

case File.read("./Day11Values.txt") do
  {:ok, body}      -> Day11.find_num_of_seats_after_no_changes(body)
  {:error, reason} -> IO.puts(reason)
end
