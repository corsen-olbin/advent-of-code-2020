defmodule AdventOfCode2020.CLI do
  @default_part 1

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    OptionParser.parse(
      argv,
      switches: [help: :boolean],
      aliases: [h: :help]
    )
    |> elem(1)
    |> args_to_internal_representation
  end

  @spec args_to_internal_representation(any) :: :help | {integer, integer}
  def args_to_internal_representation([day]), do: { String.to_integer(day), @default_part }
  def args_to_internal_representation([day, part]), do: { String.to_integer(day), String.to_integer(part) }
  def args_to_internal_representation(_), do: :help

  def process(:help) do
    IO.puts """
    usage: aoc <day> [ part | #{@default_part} ]
    """
    System.halt(0)
  end

  def process({day, part}) do
    AOCProcessor.process(day, part)
    |> print_results
  end

  def print_results(result) do
    IO.puts(result)
  end
end
