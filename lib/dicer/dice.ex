defprotocol Dicer.Dice do
  def roll(dice)
end

defimpl Dicer.Dice, for: Dicer.Tokens.Dice do
  def roll(dice) do
    _do_roll(dice.quantity, dice.sides, [])
  end

  defp _do_roll(0, _sides, results) do
      results
  end

  defp _do_roll(rolls_left, sides, results) when rolls_left > 0 do
      _do_roll(rolls_left - 1, sides, [:sfmt.uniform(sides)] ++ results)
  end
end

defimpl Dicer.Dice, for: Dicer.Tokens.FudgeDice do
  def roll(dice) do
    _do_roll(dice.quantity, [])
  end

  defp _do_roll(0, results) do
      results
  end

  defp _do_roll(rolls_left, results) when rolls_left > 0 do
      case :sfmt.uniform(3) do
        1 ->
          _do_roll(rolls_left - 1, [-1.0] ++ results)
        2 ->
          _do_roll(rolls_left - 1, [0.0] ++ results)
        3 ->
          _do_roll(rolls_left - 1, [1.0] ++ results)
      end
  end
end