defmodule Dicer do

  def parse(dice_str, validate \\ true)

  def parse(dice_str, true) when is_binary(dice_str) and dice_str != "" do

    case dice_str |> Dicer.Validator.validate do
      {:ok, valid_str, []}            -> valid_str |> _parse
      {:error, _invalid_str, reason}  -> IO.puts reason
      _                               -> {:error, ["Unknown error!!!\n"]}
    end
  end

  def parse(dice_str, false) when is_binary(dice_str) and dice_str != "" do
    dice_str
    |> Dicer.Parser.parse
  end

  def roll do
    raise "NOT IMPLEMENTED!!!"
  end
end