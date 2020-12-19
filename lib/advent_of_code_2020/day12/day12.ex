defmodule Day12 do
  @external_resource Path.join(__DIR__, "Day12Values.txt")

  def process(part) do
    case File.read(@external_resource) do
      {:ok, body} ->
        case part do
          1 -> find_manhattan_distance(body)
          2 -> find_manhattan_distance_w_waypoint(body)
        end
      {:error, reason} -> :file.format_error(reason)
    end
  end

  # part 1
  def find_manhattan_distance(body) do
    body
    |> String.split("\r\n")
    |> Enum.map(fn x -> parse_command(x) end)
    |> follow_commands
    |> calculate_manhattan_distance
    |> format_results_part1
  end

  def parse_command(command) do
    capture = Regex.named_captures(~r/(?<command>\w)(?<unit>\d+)/, command)
    {capture["command"], capture["unit"] |> String.to_integer }
  end

  def follow_commands(list), do: follow_commands_rec(list, 0, 0, 90)

  def follow_commands_rec([], x, y, _), do: {x, y}
  def follow_commands_rec([head | list], x, y, d) do
    case head do
      {"N", unit} -> follow_commands_rec(list, x, y + unit, d)
      {"S", unit} -> follow_commands_rec(list, x, y - unit, d)
      {"E", unit} -> follow_commands_rec(list, x + unit, y, d)
      {"W", unit} -> follow_commands_rec(list, x - unit, y, d)
      {"L", unit} -> follow_commands_rec(list, x, y, rem(360 + d - unit, 360))
      {"R", unit} -> follow_commands_rec(list, x, y, rem(360 + d + unit, 360))
      {"F", unit} -> forward_command(list, x, y, d, unit)
    end
  end

  def forward_command(list, x, y, d, unit) do
    case d do
      0   -> follow_commands_rec(list, x, y + unit, d)
      180 -> follow_commands_rec(list, x, y - unit, d)
      90  -> follow_commands_rec(list, x + unit, y, d)
      270 -> follow_commands_rec(list, x - unit, y, d)
    end
  end

  def calculate_manhattan_distance({x, y}), do: abs(x) + abs(y)

  def format_results_part1(distance) do
    "Manhattan distance: #{distance}"
  end

  # part 2
  def find_manhattan_distance_w_waypoint(body) do
    body
    |> String.split("\r\n")
    |> Enum.map(fn x -> parse_command(x) end)
    |> follow_waypoint_commands
    |> calculate_manhattan_distance
    |> format_results_part2
  end

  def follow_waypoint_commands(list), do: follow_waypoint_commands_rec(list, 0, 0, 10, 1, 90, 0)

  def follow_waypoint_commands_rec([], x, y, _, _, _, _), do: {x, y}
  def follow_waypoint_commands_rec([head | list], x, y, w1, w2, d1, d2) do
    case head do
      {"N", unit} -> follow_waypoint_commands_rec(list, x, y, calc_waypoint(0, w1, d1, unit), calc_waypoint(0, w2, d2, unit), d1, d2)
      {"S", unit} -> follow_waypoint_commands_rec(list, x, y, calc_waypoint(180, w1, d1, unit), calc_waypoint(180, w2, d2, unit), d1, d2)
      {"E", unit} -> follow_waypoint_commands_rec(list, x, y, calc_waypoint(90, w1, d1, unit), calc_waypoint(90, w2, d2, unit), d1, d2)
      {"W", unit} -> follow_waypoint_commands_rec(list, x, y, calc_waypoint(270, w1, d1, unit), calc_waypoint(270, w2, d2, unit), d1, d2)
      {"L", unit} -> follow_waypoint_commands_rec(list, x, y, w1, w2, rem(360 + d1 - unit, 360), rem(360 + d2 - unit, 360))
      {"R", unit} -> follow_waypoint_commands_rec(list, x, y, w1, w2, rem(360 + d1 + unit, 360), rem(360 + d2 + unit, 360))
      {"F", unit} -> forward_waypoint_command(list, x, y, w1, w2, d1, d2, unit)
    end
  end

  def calc_waypoint(direction, w, d, unit) do
    case abs(direction - d) do
      0   -> w + unit
      180 -> w - unit
      90  -> w
      270 -> w
    end
  end

  def forward_waypoint_command(list, x, y, w1, w2, d1, d2, unit) do
    case {d1, d2} do
      {90, 0}     -> follow_waypoint_commands_rec(list, x + (w1 * unit), y + (w2 * unit), w1, w2, d1, d2)
      {180, 90}   -> follow_waypoint_commands_rec(list, x + (w2 * unit), y - (w1 * unit), w1, w2, d1, d2)
      {270, 180}  -> follow_waypoint_commands_rec(list, x - (w1 * unit), y - (w2 * unit), w1, w2, d1, d2)
      {0, 270}    -> follow_waypoint_commands_rec(list, x - (w2 * unit), y + (w1 * unit), w1, w2, d1, d2)
    end
  end

  def format_results_part2(distance) do
    "Manhattan distance w/ waypoints: #{distance}"
  end
end
