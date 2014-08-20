defmodule Dice do
  # TODO: Move terms to separate files
  defmodule ParsedScalarTerm do
    defstruct operand: nil, value: 0
  
    def new([_, operand, value, _rest]) do
      op = Dice.determine_operand(operand)
      {val, _} = Integer.parse(value)
      %ParsedScalarTerm{operand: op, value: val}
    end
  end

  defmodule ParsedDiceTerm do
    defstruct operand: nil, quantity: 0, sides: 10

    def new([_, operand, quantity, sides, _rest]) do
      op = Dice.determine_operand(operand)
      {quant, _} = Integer.parse(quantity)
      {num_of_sides, _} = Integer.parse(sides)
      %ParsedDiceTerm{operand: op, quantity: quant, sides: num_of_sides}
    end
  end

  defmodule ParsedComplexTerm do
    defstruct operand: nil, terms: []

    def new([_, operand, _terms, _rest], parsed_terms) do
      op = Dice.determine_operand(operand)
      %ParsedComplexTerm{operand: op, terms: parsed_terms}
    end
  end

  def create(dice_str) when is_binary(dice_str) and dice_str != "" do
    Dice.Parser.parse(dice_str)
  end

  def roll do
    raise "NOT IMPLEMENTED!!!"
  end

  # TODO: Move to Helper module and import to terms
  def determine_operand("") do
    "+"
  end

  def determine_operand(operand) when is_binary(operand) and byte_size(operand) == 1 do
    operand
  end
end