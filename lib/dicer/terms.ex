defmodule Dicer.Terms do
  import Dicer.Helpers

  defmodule Scalar do
    defstruct operand: nil, value: 0

    def new([_, operand, value, _rest]) do
      op = determine_operand(operand)
      {val, _} = Integer.parse(value)
      %Scalar{operand: op, value: val}
    end
  end

  defmodule Dice do
    defstruct operand: nil, quantity: 0, sides: 10

    def new([_, operand, quantity, sides, _rest]) do
      op = determine_operand(operand)
      {quant, _} = Integer.parse(quantity)
      {num_of_sides, _} = Integer.parse(sides)
      %Dice{operand: op, quantity: quant, sides: num_of_sides}
    end
  end

  defmodule Complex do
    defstruct operand: nil, terms: []

    def new([_, operand, _terms, _rest], parsed_terms) do
      op = determine_operand(operand)
      %Complex{operand: op, terms: parsed_terms}
    end
  end
end