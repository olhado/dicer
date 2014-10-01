defmodule Dicer.Roller do

  def roll_dice(input) when is_list(input) do
    << a :: 32, b :: 32, c :: 32 >> = :crypto.rand_bytes(12)
    :random.seed(a,b,c)
    _roll(input)
  end

  defp _roll(input, output \\ [])
  defp _roll([], output) do
    output
  end

  defp _roll(input = [%Dicer.Tokens.Dice{} | tail], output) do
    dice = hd(input)
    roll_results = _do_roll(dice.quantity, dice.sides, [])
    _roll(tail, output ++ [%{dice | values: roll_results}])
  end

  defp _roll([head | tail], output) do
    _roll(tail, output ++ [head])
  end

  defp _do_roll(0, _sides, results) do
    results
  end

  defp _do_roll(rolls_left, sides, results) do
    _do_roll(rolls_left - 1, sides, results ++ [:random.uniform(sides)])
  end
end