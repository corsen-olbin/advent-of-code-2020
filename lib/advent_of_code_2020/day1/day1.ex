defmodule Day1 do
  @external_resource Path.join(__DIR__, "AdventOfCodeDay1Values.txt")

  def process(part) do
    case File.read(@external_resource) do
      {:ok, body} ->
        case part do
          1 -> find_2020_pair_product(body)
          2 -> find_2020_triplet_product(body)
        end
      {:error, reason} -> :file.format_error(reason)
    end
  end

  # part 1
  def find_2020_pair_product(body) do
    body
    |> String.split
    |> Enum.map(fn x -> String.to_integer(x) end)
    |> find_2020_pair
    |> format_results1
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

  defp format_results1({x, y}) do
    """
    Proof: #{x} + #{y} = #{x + y}
    Product: #{x} * #{y} = #{x * y}
    """
  end

  # part 2
  def find_2020_triplet_product(body) do
    body
    |> String.split()
    |> Enum.map(fn x -> String.to_integer(x) end)
    |> find_2020_triplet()
    |> format_results2
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

  defp format_results2({x, y, z}) do
    """
    Proof: #{x} + #{y} + #{z} = #{x + y + z}
    Product: #{x} * #{y} * #{z} = #{x * y * z}
    """
  end
end
