defmodule AOCDay4 do
  def find_num_of_valid_passports(body) do
    body
    |> String.split("\r\n\r\n")
    |> Enum.count(fn x -> check_valid_passport(x) end)
    |> print_results()

  end

  defp check_valid_passport(passport) do
    check_valid_byr(passport) and
    check_valid_iyr(passport) and
    check_valid_eyr(passport) and
    check_valid_hgt(passport) and
    check_valid_hcl(passport) and
    check_valid_ecl(passport) and
    check_valid_pid(passport)
  end

  defp check_valid_byr(passport) do
    case Regex.named_captures(~r/byr:(?<year>[0-9]+)/, passport) do
      nil -> false
      byr -> String.length(byr["year"]) == 4 and check_range(String.to_integer(byr["year"]), 1920, 2002)
    end
  end

  defp check_valid_iyr(passport) do
    case Regex.named_captures(~r/iyr:(?<year>[0-9]+)/, passport) do
      nil -> false
      iyr -> String.length(iyr["year"]) == 4 and check_range(String.to_integer(iyr["year"]), 2010, 2020)
    end
  end

  defp check_valid_eyr(passport) do
    case Regex.named_captures(~r/eyr:(?<year>[0-9]+)/, passport) do
      nil -> false
      eyr -> String.length(eyr["year"]) == 4 and check_range(String.to_integer(eyr["year"]), 2020, 2030)
    end
  end

  defp check_valid_hgt(passport) do
    case Regex.named_captures(~r/hgt:(?<value>[0-9]+)(?<unit>cm|in)/, passport) do
      nil -> false
      hgt -> check_height(hgt)
    end
  end

  defp check_height(hgt) do
    case hgt["unit"] do
      "cm" -> check_range(String.to_integer(hgt["value"]), 150, 193)
      "in" -> check_range(String.to_integer(hgt["value"]), 59, 76)
      _ -> false
    end
  end

  defp check_valid_hcl(passport) do
    case Regex.named_captures(~r/hcl:#(?<value>[a-f0-9]+)/, passport) do
      nil -> false
      hcl -> String.length(hcl["value"]) == 6
    end
  end

  defp check_valid_ecl(passport), do: Regex.match?(~r/ecl:(amb|blu|brn|gry|grn|hzl|oth)/, passport)

  defp check_valid_pid(passport) do
    case Regex.named_captures(~r/pid:(?<value>[0-9]+)/, passport) do
      nil -> false
      pid -> String.length(pid["value"]) == 9
    end
  end

  defp check_range(value, min, max), do: value >= min and value <= max

  defp print_results(num), do: IO.puts("# of valid passports: #{num}")

end


case File.read("./Day4Values.txt") do
  {:ok, body}      -> AOCDay4.find_num_of_valid_passports(body)
  {:error, reason} -> IO.puts(reason)
end
