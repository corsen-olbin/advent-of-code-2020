defmodule AOCDay5 do
  def find_missing_boarding_id(body) do
    body
    |> String.split("\r\n")
    |> Enum.map(fn x -> calculate_boarding_id(x) end)
    |> locate_missing_boarding_id()
    |> print_results()
  end

  def calculate_boarding_id(x) do
    case x do
      seat ->
        calculate_boarding_id_rec(String.slice(seat, 0..6), 0, 127) * 8 + calculate_boarding_id_rec(String.slice(seat, 7..9), 0, 7)
    end
  end

  def calculate_boarding_id_rec(seat, min, max) do
    case seat do
      _ when min == max -> min
      <<"F", rest::binary>> -> calculate_boarding_id_rec(rest, min, (max + min + 1)/2 - 1)
      <<"B", rest::binary>> -> calculate_boarding_id_rec(rest, (max + min + 1)/2, max)
      <<"L", rest::binary>> -> calculate_boarding_id_rec(rest, min, (max + min + 1)/2 - 1)
      <<"R", rest::binary>> -> calculate_boarding_id_rec(rest, (max + min + 1)/2, max)
    end
  end

  def locate_missing_boarding_id(ids), do: Enum.find(ids, fn x -> check_ids(ids, x+1, x, x+2) end) + 1

  def check_ids(ids, actual, below, above) do
    Enum.any?(ids, fn x -> x == below end) and
    Enum.any?(ids, fn x -> x == above end) and
    Enum.all?(ids, &(&1 != actual))
  end

  defp print_results(missing_id), do: IO.puts("Missing boarding pass Id: #{missing_id}")
end

case File.read("./Day5Values.txt") do
  {:ok, body}      -> AOCDay5.find_missing_boarding_id(body)
  {:error, reason} -> IO.puts(reason)
end
