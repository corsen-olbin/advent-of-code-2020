defmodule AOCDay3 do
  def find_num_of_valid_passports(body) do
    body
    |> String.split("\r\n\r\n")
    |> Enum.map(fn x -> map_fields(x) end)
    |> Enum.count()
  end

  defp map_fields() do
    ~r//
  end

end


case File.read("./Day3Values.txt") do
  {:ok, body}      -> AOCDay3.find_num_of_trees(body)
  {:error, reason} -> IO.puts(reason)
end
