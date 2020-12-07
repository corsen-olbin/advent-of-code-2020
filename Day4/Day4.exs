defmodule AOCDay4 do
  def find_num_of_valid_passports(body) do
    body
    |> String.split("\r\n\r\n")
    |> Enum.count(fn x -> check_valid_passport(x) end)
    |> print_results()

  end

  defp check_valid_passport(passport) do
    Regex.match?(~r/byr:[a-z0-9#]+/, passport) and
    Regex.match?(~r/iyr:[a-z0-9#]+/, passport) and
    Regex.match?(~r/eyr:[a-z0-9#]+/, passport) and
    Regex.match?(~r/hgt:[a-z0-9#]+/, passport) and
    Regex.match?(~r/hcl:[a-z0-9#]+/, passport) and
    Regex.match?(~r/ecl:[a-z0-9#]+/, passport) and
    Regex.match?(~r/pid:[a-z0-9#]+/, passport)
  end

  defp print_results(num), do: IO.puts("# of valid passports: #{num}")

end


case File.read("./Day4Values.txt") do
  {:ok, body}      -> AOCDay4.find_num_of_valid_passports(body)
  {:error, reason} -> IO.puts(reason)
end
