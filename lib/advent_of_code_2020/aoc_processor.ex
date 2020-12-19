defmodule AOCProcessor do

  def process(day, part) do
    case day do
      1 -> Day1.process(part)
      12 -> Day12.process(part)
    end
  end
end
