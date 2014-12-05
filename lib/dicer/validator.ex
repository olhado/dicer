defmodule Dicer.Validator do
    @invalid_operator_sequences [%Dicer.Tokens.Plus{}, %Dicer.Tokens.Minus{}, %Dicer.Tokens.Multiply{}, %Dicer.Tokens.Divide{}]
    @invalid_operators_at_start [%Dicer.Tokens.Multiply{}, %Dicer.Tokens.Divide{}]

  def validate({:ok, input}, validation_options) when is_list(input) and is_map(validation_options) do
    {:ok, input}
    |> _validate_proper_input_start(input)
    |> _validate_proper_input_end(input)
    |> _validate_operator_sequence(input)
    |> _validate_max_dice(input, validation_options)
    |> _validate_max_sides(input, validation_options)
  end

  def validate(input = {:error, _}, _validation_options) do
    input
  end

  defp _validate_operator_sequence(input = {:error, _}, _) do
    input
  end

  defp _validate_operator_sequence({:ok, [head | tail]}, input) do
    case Enum.member?(@invalid_operator_sequences, head) and Enum.member?(@invalid_operator_sequences, hd(tail)) do
      true -> {:error, ["Improper operator format (Ex. 1--1)!"]}
      _ -> _validate_operator_sequence({:ok, tail}, input)
    end
  end

  defp _validate_operator_sequence({:ok,[]}, input) do
    {:ok, input}
  end

  defp _validate_proper_input_end(input = {_, _}, [%Dicer.Tokens.End{}]) do
    input
  end

  defp _validate_proper_input_end(input = {:error, _}, _) do
    input
  end

  defp _validate_proper_input_end({:ok, input}, input) do
    case Enum.member?(@invalid_operator_sequences, hd(tl(Enum.reverse(input)))) do
      true -> {:error, ["Trailing operator(s) on input!"]}
      _ -> {:ok, input}
    end
  end

  defp _validate_proper_input_start(input = {_, _}, [%Dicer.Tokens.End{}]) do
    input
  end

  defp _validate_proper_input_start(input = {:error, _}, _) do
    input
  end

  defp _validate_proper_input_start({:ok, input}, input) do
    case Enum.member?(@invalid_operators_at_start, hd(input)) do
      true -> {:error, ["Invalid operator(s) at beginning of input!"]}
      _ -> {:ok, input}
    end
  end

  defp _validate_max_dice(input = {:error, _}, _, _) do
    input
  end

  defp _validate_max_dice({:ok, input}, input, %{max_dice: max}) when is_integer(max) and max > 0 do
    case Enum.reduce(input, 0, fn(token, acc) -> if _is_dice(token), do: acc + token.quantity, else: acc end) do
      total when total > max -> {:error, "Number of dice exceeds maximum allowed: #{max}"}
      _ -> {:ok, input}
    end
  end

  defp _validate_max_sides(input = {:error, _}, _, _) do
    input
  end

  defp _validate_max_sides({:ok, input}, input, %{max_sides: max}) when is_integer(max) and max > 0 do
    case Enum.reduce(input, 0, fn(token, acc) -> if _is_dice(token) and token.sides > acc, do: token.sides, else: acc end) do
      total when total > max -> {:error, "Number of sides exceeds maximum allowed: #{max}"}
      _ -> {:ok, input}
    end
  end

  defp _is_dice(%{__struct__: var}) when var in [Dicer.Tokens.Dice, Dicer.Tokens.FudgeDice] do
    true
  end

  defp _is_dice(_) do
    false
  end
end