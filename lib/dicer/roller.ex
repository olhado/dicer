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
    next_token = hd(tail)

    roll_results = Dice.roll(dice)

    case next_token do

      %Tokens.TakeTop{} ->
        sorted_rolls = Enum.reverse(Enum.sort(roll_results))
        c_vals = Enum.take(sorted_rolls, next_token.take_num)
        r_vals = sorted_rolls -- c_vals
        _roll(tl(tail), [next_token | [%{dice | counted_values: c_vals, rejected_values: r_vals, raw_rolls: roll_results} | output]])

      %Tokens.TakeBottom{} ->
        sorted_rolls = Enum.sort(roll_results)
        c_vals = Enum.take(sorted_rolls, next_token.take_num)
        r_vals = sorted_rolls -- c_vals
        _roll(tl(tail), [next_token | [%{dice | counted_values: c_vals, rejected_values: r_vals, raw_rolls: roll_results} | output]])

      _ ->
        _roll(tail, [%{dice | counted_values: roll_results, raw_rolls: roll_results} | output])
    end
  end

  defp _roll(input = [%Tokens.FudgeDice{} | tail], output) do
    dice = hd(input)
    roll_results = Dice.roll(dice)
    _roll(tail, [%{dice | counted_values: roll_results, raw_rolls: roll_results} | output])
  end

  defp _roll([head | tail], output) do
    _roll(tail, [head | output])
  end
end