defmodule DicerTest do
  use ExUnit.Case

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "blank input" do
    assert Dicer.roll("") == {[%Dicer.Tokens.End{}], 0.0}
  end

  test "single integer" do
    assert Dicer.roll("1") == {[%Dicer.Tokens.End{}], 1.0}
  end

  test "single float" do
    assert Dicer.roll("1.23456789") == {[%Dicer.Tokens.End{}], 1.2346}
  end

  test "rolling dice" do
    assert Dicer.roll("10d1") == {[%Dicer.Tokens.End{}], 10.0}
  end

  test "addition" do
    assert Dicer.roll("1+0.5") == {[%Dicer.Tokens.End{}], 1.5}
  end

  test "subtraction" do
    assert Dicer.roll("1-0.5") == {[%Dicer.Tokens.End{}], 0.5}
  end

  test "multiplication" do
    assert Dicer.roll("1*0.5") == {[%Dicer.Tokens.End{}], 0.5}
  end

  test "division" do
    assert Dicer.roll("1/0.5") == {[%Dicer.Tokens.End{}], 2.0}
  end

  test "parentheses" do
    assert Dicer.roll("(1.2222)") == {[%Dicer.Tokens.End{}], 1.2222}
  end

  test "dice roll results stay in expected range" do
    for _ <- 1..100 do
      {end_token, value} = Dicer.roll("2d20")
      # IO.puts value # TODO: Replace with Logger!
      assert end_token == [%Dicer.Tokens.End{}]
      assert value >= 2 and value <= 40
    end
  end

  test "nested parentheses" do
    assert Dicer.roll("1-(6-((12)+400))") == {[%Dicer.Tokens.End{}], 407.0}
  end

  test "all operators together" do
    assert Dicer.roll("1000-350/2*3+(100/(20*5))-575+100d1") == {[%Dicer.Tokens.End{}], 1.0}
  end
end
