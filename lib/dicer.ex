defmodule Dicer do

  def parse(dice_str) when is_binary(dice_str) and dice_str != "" do
    Dicer.Parser.parse(dice_str, true)
  end

  def roll do
    raise "NOT IMPLEMENTED!!!"
  end
end