defmodule Dicer.Roller do
  alias Dicer.Tokens
  alias Dicer.Dice

  def roll_dice({:ok, input}) when is_list(input) do
    << a :: 32, b :: 32, c :: 32 >> = :crypto.rand_bytes(12)
    :sfmt.seed(a,b,c)
    _roll(input)
  end

  def roll_dice(input = {:error, _}) do
    input
  end

  defp _roll(input, output \\ [])
  defp _roll([], output) do
    {:ok, Enum.reverse output}
  end

  defp _roll(input = [%Tokens.Dice{} | tail], output) do
    dice = hd(input)
    roll_results = Dice.roll(dice)
    _roll(tail, [%{dice | counted_values: roll_results}] ++ output)
  end

  defp _roll(input = [%Tokens.FudgeDice{} | tail], output) do
    dice = hd(input)
    roll_results = Dice.roll(dice)
    _roll(tail, [%{dice | counted_values: roll_results}] ++ output)
  end

  defp _roll([head | tail], output) do
    _roll(tail, [head] ++ output)
  end
end