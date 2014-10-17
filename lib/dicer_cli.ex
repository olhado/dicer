defmodule Dicer.CLI do

  def main(args) do
    args |> parse_args
  end

  def parse_args(args) do
    options = OptionParser.parse(args)
    IO.inspect options
    case options do
      { _, [ input ], _ } ->
        IO.inspect(Dicer.roll(input))
      _ ->
        exit(1)
    end
  end
end