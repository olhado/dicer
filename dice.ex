defmodule Dice do
  defmodule Scalar_Term, do: defstruct operand: nil, value: 0
  defmodule Die_Term, do: defstruct operand: nil, quantity: 0, sides: 10
  defmodule Complex_Term, do: defstruct operand: nil, terms: []

  def parse(dice_str) when is_binary(dice_str) do
      stripped_str = _strip_spaces(dice_str)

      validation_result = _validate(stripped_str) 
      case validation_result do
        {:ok, []} ->
          IO.inspect _parse(stripped_str)
          IO.puts stripped_str
        {:error, reason} ->
          IO.puts reason
        _ ->
          {:error, ["Unknown error!!!\n"]}
      end
  end

  defp _validate(dice_str) do
    {:ok, []}
    |> _valid_chars?(dice_str)
    |> _correct_num_of_parens?(dice_str)
    |> _empty_parens_clauses?(dice_str)

  end

  defp _valid_chars?(validation_tuple = {_, messages}, dice_str) do
    valid_str = Regex.match?(~r/^[0-9d\-\+\*\/\(\)]+$/i, dice_str)

    cond do
      !valid_str  -> {:error, ["Dice string has invalid characters!\n" | messages]}
      valid_str   -> validation_tuple
    end
  end

  defp _correct_num_of_parens?(validation_tuple = {_, messages}, dice_str) do
    parens_count = _count_parens(dice_str, 0)

    if parens_count != 0 do
      {:error, ["Parentheses do not match!\n" | messages]}
    else
      validation_tuple
    end
  end

  defp _count_parens("", parens_count) do
    parens_count
  end

  defp _count_parens(dice_str, parens_count) do
    char = String.at(dice_str, 0)
    case char do
      "("   -> _count_parens(String.slice(dice_str, 1..-1), parens_count + 1)
      ")"   -> _count_parens(String.slice(dice_str, 1..-1), parens_count - 1)
      _     -> _count_parens(String.slice(dice_str, 1..-1), parens_count)
    end
  end

  defp _empty_parens_clauses?(validation_tuple = {_, messages}, dice_str) do
    match = Regex.match?(~r/\(\)/i, dice_str)

    if match do
      {:error, ["Empty clause in input!\n" | messages]}
    else
      validation_tuple
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
        [_, operand, sides, rest] = match
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