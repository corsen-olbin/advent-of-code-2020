defmodule AOCDay1 do
  def find_2020_triplet_product(body) do
    body
    |> String.split()
    |> Enum.map(fn x -> String.to_integer(x) end)
    |> find_2020_triplet()
    |> print_results()
  end

  def find_2020_triplet(ints) do
    case ints do
      []            -> raise "could not find pair that added up to 2020"
      [head | tail] -> find_2020_triplet2(tail, head, tail)
    end
  end

  def find_2020_triplet2(originaltail, head, tail) do
    case tail do
      []            -> find_2020_triplet(originaltail)
      [head1 | tail1] -> search_triplet(originaltail, head, head1, tail1)
    end
  end

  defp search_triplet(originaltail, head1, head2, tail) do
    case Enum.find(tail, fn x -> head1 + head2 + x == 2020 end) do
      nil -> find_2020_triplet2(originaltail, head1, tail)
      x   -> {head1, head2, x}
    end
  end

  defp print_results({x, y, z}) do
    IO.puts("Proof: #{x} + #{y} + #{z} = #{x + y + z}")
    IO.puts("Product: #{x} * #{y} * #{z} = #{x * y * z}")
  end
end

case File.read("./AdventOfCodeDay1Values.txt") do
  {:ok, body}      -> AOCDay1.find_2020_triplet_product(body)
  {:error, reason} -> IO.puts(reason)
end
