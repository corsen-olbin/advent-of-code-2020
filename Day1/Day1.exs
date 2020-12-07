defmodule AOCDay1 do
  def find_2020_pair_product(body) do
    body
    |> String.split()
    |> Enum.map(fn x -> String.to_integer(x) end)
    |> find_2020_pair()
    |> print_results()
  end

  def find_2020_pair(ints) do
    case ints do
      []            -> raise "could not find pair that added up to 2020"
      [head | tail] -> search_pairs(head, tail)
    end
  end

  defp search_pairs(head, tail) do
    case Enum.find(tail, fn x -> x + head == 2020 end) do
      nil -> find_2020_pair(tail)
      x   -> {head, x}
    end
  end

  defp print_results({x, y}) do
    IO.puts("Proof: #{x} + #{y} = #{x + y}")
    IO.puts("Product: #{x} * #{y} = #{x * y}")
  end
end

case File.read("./AdventOfCodeDay1Values.txt") do
  {:ok, body}      -> AOCDay1.find_2020_pair_product(body)
  {:error, reason} -> IO.puts(reason)
end
