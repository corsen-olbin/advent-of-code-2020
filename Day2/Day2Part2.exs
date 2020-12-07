defmodule AOCDay2 do
  def find_num_of_valid_passwords(body) do
    body
    |> String.split("\r\n")
    |> Enum.map(fn x -> Regex.named_captures(~r/(?<pos1>\d+)-(?<pos2>\d+) (?<character>\w): (?<password>[a-z]+)/, x) end)
    |> Enum.count(fn x -> check_valid_password(x) end)
    |> print_results()
  end

  def check_valid_password(input) do
    pos1char = String.at(input["password"], String.to_integer(input["pos1"]) - 1)
    pos2char = String.at(input["password"], String.to_integer(input["pos2"]) - 1)
    xor(input["character"] == pos1char, input["character"] == pos2char)
  end

  defp xor(bool1, bool2), do: (not bool1 and bool2) or (bool1 and not bool2)

  defp print_results(num) do
    IO.puts("Number of valid passwords: #{num}")
  end
end

case File.read("./AdventOfCodeDay2Values.txt") do
  {:ok, body}      -> AOCDay2.find_num_of_valid_passwords(body)
  {:error, reason} -> IO.puts(reason)
end
