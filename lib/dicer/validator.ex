defmodule Dicer.Validator do
    @invalid_operator_sequences [%Dicer.Tokens.Plus{}, %Dicer.Tokens.Minus{}, %Dicer.Tokens.Multiply{}, %Dicer.Tokens.Divide{}]
    @invalid_operators_at_start [%Dicer.Tokens.Multiply{}, %Dicer.Tokens.Divide{}]

  def validate({:ok, input}) when is_list(input) do
    {:ok, input}
    |> _validate_proper_input_start(input)
    |> _validate_proper_input_end(input)
    |> _validate_operator_sequence(input)
  end

  def validate(input = {:error, _}) do
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
end