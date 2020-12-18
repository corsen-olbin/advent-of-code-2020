defmodule Day11 do

  def find_num_of_seats_after_no_changes(body) do
    body
    |> String.split("\r\n")
    |> Matrix.build_matrix
    |> my_inspect
    |> find_first_repeated_matrix
    |> calculate_num_occupied
    |> print_results
  end

  defp my_inspect(map) do
    IO.puts(Map.keys(map) |> Enum.max())
    IO.puts(Map.keys(map[0]) |> Enum.max())
    map
  end

  defp calculate_num_occupied(map) do
    map
    |> Map.values
    |> Enum.map(fn x -> Enum.count(Map.values(x), fn value -> value == "#" end) end)
    |> Enum.sum
  end
  defp print_results(sum), do: IO.puts("# of seats that are occupied after no changes: #{sum}")

  def find_first_repeated_matrix(current_map) do
    # IO.puts("Inside find_first_repeated_matrix")
    case calculate_next_state(current_map) do
      { false, change_map } -> change_map
      { true, change_map }  -> find_first_repeated_matrix(change_map)
    end
  end

  def calculate_next_state(seat_map), do: calculate_next_state_rec(seat_map, seat_map, 0, 0, false)
  defp calculate_next_state_rec(current_map, change_map, x, y, is_change) do
    case current_map[x][y] do
      "L" -> check_to_become_occupied(current_map, change_map, x, y, is_change)
      "#" -> check_to_become_unoccupied(current_map, change_map, x, y, is_change)
      "." -> increment_x_y(current_map, change_map, x, y, is_change)
    end
  end

  def check_to_become_occupied(current_map, change_map, x, y, is_change) do
    surrounding = [
      recurse_search_direction(current_map, x, y, &(&1 - 1), &(&1 - 1)),
      recurse_search_direction(current_map, x, y, &(&1 - 1), &(&1)    ),
      recurse_search_direction(current_map, x, y, &(&1 - 1), &(&1 + 1)),
      recurse_search_direction(current_map, x, y, &(&1)    , &(&1 - 1)),
      recurse_search_direction(current_map, x, y, &(&1)    , &(&1 + 1)),
      recurse_search_direction(current_map, x, y, &(&1 + 1), &(&1 - 1)),
      recurse_search_direction(current_map, x, y, &(&1 + 1), &(&1)    ),
      recurse_search_direction(current_map, x, y, &(&1 + 1), &(&1 + 1)),
    ]

    case Enum.count(surrounding, fn x -> x == "#" end) == 0 do
      true -> increment_x_y(current_map, Matrix.update(change_map, x, y, "#"), x, y, true)
      false -> increment_x_y(current_map, change_map, x, y, is_change or false)
    end
  end

  def check_to_become_unoccupied(current_map, change_map, x, y, is_change) do
    surrounding = [
      recurse_search_direction(current_map, x, y, &(&1 - 1), &(&1 - 1)),
      recurse_search_direction(current_map, x, y, &(&1 - 1), &(&1)    ),
      recurse_search_direction(current_map, x, y, &(&1 - 1), &(&1 + 1)),
      recurse_search_direction(current_map, x, y, &(&1)    , &(&1 - 1)),
      recurse_search_direction(current_map, x, y, &(&1)    , &(&1 + 1)),
      recurse_search_direction(current_map, x, y, &(&1 + 1), &(&1 - 1)),
      recurse_search_direction(current_map, x, y, &(&1 + 1), &(&1)    ),
      recurse_search_direction(current_map, x, y, &(&1 + 1), &(&1 + 1)),
    ]

    case Enum.count(surrounding, fn x -> x == "#" end) > 4 do
      true -> increment_x_y(current_map, Matrix.update(change_map, x, y, "L"), x, y, true)
      false -> increment_x_y(current_map, change_map, x, y, is_change or false)
    end
  end

  defp recurse_search_direction(current_map, x, y, xfun, yfun) do
    new_x = xfun.(x)
    new_y = yfun.(y)
    case Matrix.get(current_map, new_x, new_y, "!") do
      "#" -> "#"
      "L" -> "L"
      "!" -> "!"
      "." -> recurse_search_direction(current_map, new_x, new_y, xfun, yfun)
    end
  end

  def increment_x_y(current_map, change_map, x, y, is_change) do
    case Map.get(current_map, x) |> Map.get(y + 1) do
      nil -> case Map.get(current_map, x + 1) do
        nil -> {is_change, change_map}
        _ -> calculate_next_state_rec(current_map, change_map, x + 1, 0, is_change)
      end
      _ -> calculate_next_state_rec(current_map, change_map, x, y + 1, is_change)
    end
  end

end


defmodule Matrix do
  @moduledoc """
  This module is for working with 2D data.

  For example it can turn
  ```
  L.L
  ..L
  L..
  ```
  into
  ```
  %{
    0 => %{ 0 => "L", 1 => ".", 2 => "L" },
    1 => %{ 0 => ".", 1 => ".", 2 => "L" },
    2 => %{ 0 => "L", 1 => ".", 2 => "." }
  }
  ```
  """
  def get(map, x, y, default) do
    map
    |> Map.get(x, %{})
    |> Map.get(y, default)
  end

  def update(map, x, y, value) do
    Map.update!(map, x, fn inner -> %{ inner | y => value } end)
  end

  def build_matrix(string_list), do: build_matrix_rec(%{}, 0, string_list)

  defp build_matrix_rec(acc_map, _, []), do: acc_map
  defp build_matrix_rec(acc_map, index, [head | string_list]), do: build_matrix_rec(Map.put_new(acc_map, index, build_inner_map(String.split(head, "", trim: true))), index + 1, string_list)

  defp build_inner_map(string_list), do: build_inner_map_rec(%{}, 0, string_list)

  defp build_inner_map_rec(inner_map, _, []), do: inner_map
  defp build_inner_map_rec(inner_map, index, [head | string_list]), do: build_inner_map_rec(Map.put_new(inner_map, index, head), index + 1, string_list)
end

case File.read("./Day11Values.txt") do
  {:ok, body}      -> Day11.find_num_of_seats_after_no_changes(body)
  {:error, reason} -> IO.puts(reason)
end
