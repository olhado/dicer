defmodule Dicer.Helpers do
  def determine_operand("") do
    "+"
  end

  def determine_operand(operand) when is_binary(operand) and byte_size(operand) == 1 do
    operand
  end
end