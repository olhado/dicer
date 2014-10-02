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
end
