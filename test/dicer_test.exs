defmodule DicerTest do
  use ExUnit.Case

  test "blank input" do
    assert Dicer.roll("") == {:ok, 0.0}
  end

  test "single integer" do
    assert Dicer.roll("1") == {:ok, 1.0}
  end

  test "negative number" do
    assert Dicer.roll("-1") == {:ok, -1.0}
  end

  test "positive number" do
    assert Dicer.roll("+1") == {:ok, 1.0}
  end

  test "single float" do
    assert Dicer.roll("1.23456789") == {:ok, 1.2346}
  end

  test "rolling dice" do
    assert Dicer.roll("10d1") == {:ok, 10.0}
  end

  test "rolling one die, no quantity" do
    assert Dicer.roll("1d1") == {:ok, 1.0}
  end

  test "addition" do
    assert Dicer.roll("1+0.5") == {:ok, 1.5}
  end

  test "subtraction" do
    assert Dicer.roll("1-0.5") == {:ok, 0.5}
  end

  test "multiplication" do
    assert Dicer.roll("1*0.5") == {:ok, 0.5}
  end

  test "division" do
    assert Dicer.roll("1/0.5") == {:ok, 2.0}
  end

  test "parentheses" do
    assert Dicer.roll("(1.2222)") == {:ok, 1.2222}
  end

  test "dice roll results stay in expected range" do
    for _ <- 1..100 do
      {:ok, value} = Dicer.roll("d40")
      # IO.puts value # TODO: Replace with Logger!
      assert value >= 1 and value <= 40
    end
  end

  test "nested parentheses" do
    assert Dicer.roll("1-(6-((12)+400))") == {:ok, 407.0}
  end

  test "all operators together" do
    assert Dicer.roll("1000-350/2*3+(100/(20*5))-575+100d1") == {:ok, 1.0}
  end
end
