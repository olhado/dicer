defmodule Diex do

  def parse(dice_str) when is_binary(dice_str) and dice_str != "" do
    Dice.Parser.parse(dice_str)
  end

  def roll do
    raise "NOT IMPLEMENTED!!!"
  end
end