defmodule Dice2 do
  defmodule Scalar_Term, do: defstruct operand: nil, value: 0
  defmodule Die_Term, do: defstruct operand: nil, quantity: 0, sides: 10
  defmodule Complex_Term, do: defstruct operand: nil, terms: []

  def parse(dice_str) when is_binary(dice_str) do
    parsed_dice =
      case  _validate(dice_str) do
        {:ok, validated_dice_str} ->
          IO.inspect _parse(validated_dice_str)
          IO.puts validated_dice_str
#      {:ok, validated_dice_str} -> IO.puts "Valid!!!"
        {:error, reason} ->
          IO.puts reason
      end
  end

  defp _validate(dice_str) do
    stripped_str = _strip_spaces(dice_str)
    valid_str = Regex.match?(~r|^[0-9d\-\+\*\/\(\)]+$|i, stripped_str)

    cond do
      !valid_str  -> {:error, "Dice string has invalid characters!"} 
      valid_str   -> {:ok, dice_str}
    end
  end

  defp _strip_spaces(dice_str) do
    String.replace(dice_str, " ", "")
  end

  defp _parse(dice_str, result \\ []) # Function head for defaults
  defp _parse(dice_str, result) do
    cond do
      # Die terms - Multiple dice
      match = Regex.run(~r/^([\+\-\*\/]?)(\d+?)d(\d+)(.*)/i, dice_str) ->
        [_, operand, quantity, sides, rest] = match
        IO.inspect match
        IO.inspect rest
        {quant, _} = Integer.parse(quantity)
        {num_of_sides, _} = Integer.parse(sides)
        # determine operand
        op = if operand == "", do: "+", else: operand

        _parse(rest, [%Die_Term{operand: op, quantity: quant,  sides: num_of_sides} | result])
      
      # Die terms - A single die
      match = Regex.run(~r/^([\+\-\*\/]?)d(\d+)(.*)/i, dice_str) ->
        [_, operand, _quantity, sides, rest] = match
        IO.inspect match
        IO.inspect rest
        {num_of_sides, _} = Integer.parse(sides)
        # determine operand
        op = if operand == "", do: "+", else: operand

        _parse(rest, [%Die_Term{operand: op, quantity: 1,  sides: num_of_sides} | result])
      
      # Scalar terms
      match = Regex.run(~r/^([\+\-\*\/]?)(\d+)(.*)/i, dice_str) ->
        [_, operand, value, rest] = match
        IO.inspect match
        IO.inspect rest

        # determine operand
        op = if operand == "", do: "+", else: operand

        _parse(rest, [%Scalar_Term{operand: op, value: value} | result])

      # Complex terms
      match = Regex.run(~r/^([\+\-\*\/]?)[\(]{1,1}([0-9d\-\*\+\/\(\)]+)[\)]{1,1}([\+\-\*\/]?.*)/i, dice_str) ->
        [_, operand, terms, rest] = match
        IO.inspect match

        # determine operand
        op = if operand == "", do: "+", else: operand

        _parse(rest, [%Complex_Term{operand: op, terms: _parse(terms)} | result])

      true -> 
        Enum.reverse(result)
    end
  end
end