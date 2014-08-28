defmodule Dicer.Roller do

  def roll(terms) when is_list(terms), do: _roll(terms)

  defp _roll([head | tail]) do
    # Get dice results for all terms and sub-terms
    # Calculate final result, following operator precedence
  end
end