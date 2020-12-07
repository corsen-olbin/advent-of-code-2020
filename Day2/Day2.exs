defmodule AOCDay2 do
  def find_num_of_valid_passwords(body) do
    body
    |> String.split("\r\n")
    |> Enum.map(fn x -> Regex.named_captures(~r/(?<min>\d+)-(?<max>\d+) (?<character>\w): (?<password>[a-z]+)/, x) end)
    |> Enum.count(fn x -> check_valid_password(x) end)
    |> print_results()
  end

  def check_valid_password(input) do
    min = String.to_integer(input["min"])
    max = String.to_integer(input["max"])
    num_of_chars = length(String.split(input["password"], input["character"])) - 1
    num_of_chars >= min and num_of_chars <= max
  end

  defp print_results(num) do
    IO.puts("Number of valid passwords: #{num}")
  end
end

case File.read("./AdventOfCodeDay2Values.txt") do
  {:ok, body}      -> AOCDay2.find_num_of_valid_passwords(body)
  {:error, reason} -> IO.puts(reason)
end
