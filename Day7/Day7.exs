defmodule AOCDay7 do
  def find_num_of_bags_that_can_hold_shiny_gold(body) do
    body
    |> String.split("\r\n")
    |> create_bag_map
    |> calculate_bags_that_hold_shiny_gold
    |> Enum.count
    |> print_results

  end

  def create_bag_map(rule_list) do
    rule_list
    |> Enum.map(fn x -> get_holder_and_holdee_list(x) end)
    |> Enum.filter(fn {_, v} -> v != nil and v != [] end)
    |> Enum.reduce(%{}, fn {k, v}, acc -> add_holdees_to_map(acc, k, v) end)
  end

  def get_holder_and_holdee_list(x) do
    [holder, holdees | _] = String.split(x, " contain ")
    { pull_holder(holder), pull_holdees(holdees) }
  end

  def pull_holder(holder) do
    Regex.named_captures(~r/(?<holder>[a-z]+ [a-z]+)/, holder)
    |> Map.get("holder")
  end

  def pull_holdees(holdees) do
    holdees
    |> String.split(", ")
    |> Enum.map(fn x -> pull_holdee(x) end)
    |> Enum.filter(fn x -> x != nil end)
  end

  def pull_holdee(holdee) do
    case Regex.named_captures(~r/(\d) (?<holdee>[a-z]+ [a-z]+)/, holdee) do
      nil -> []
      x   -> Map.get(x, "holdee")
    end
  end

  def add_holdees_to_map(acc, holder, holdees) do
    Enum.reduce(holdees, acc, fn (x, a) -> add_holdee_to_map(a, holder, x) end)
  end

  def add_holdee_to_map(acc, holder, holdee) do
    case Map.has_key?(acc, holdee) do
      true -> add_holder(acc, holdee, holder)
      false -> add_key_and_holder(acc, holdee, holder)
    end
  end

  def add_holder(map, key, value), do: Map.update!(map, key, fn x -> [value | x] end)

  def add_key_and_holder(map, key, value), do: Map.put(map, key, [value])

  def print_map(map) do
    IO.inspect(map)
    map
  end

  def calculate_bags_that_hold_shiny_gold(map) do
    calculate_bags_that_hold_shiny_gold_rec(map, map["shiny gold"], map["shiny gold"])
  end

  def calculate_bags_that_hold_shiny_gold_rec(_, acc, []), do: acc

  def calculate_bags_that_hold_shiny_gold_rec(map, acc, [head | tail]) do
    bags_to_check = Map.get(map, head, [])
    filtered_to_check = Enum.filter(bags_to_check, fn x -> !Enum.member?(acc, x) end)
    calculate_bags_that_hold_shiny_gold_rec(map, filtered_to_check ++ acc, filtered_to_check ++ tail)
  end

  defp print_results(num), do: IO.puts("# of bags that eventually contain at least 1 shiny gold bag: #{num}")
end

case File.read("./Day7Values.txt") do
  {:ok, body}      -> AOCDay7.find_num_of_bags_that_can_hold_shiny_gold(body)
  {:error, reason} -> IO.puts(reason)
end
