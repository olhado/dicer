defmodule Dicer.Timings do

  def time() do
    {time, _} = :timer.tc(Dicer.Timings, :same_string_compute, [1])
    IO.puts time
    {time, _} = :timer.tc(Dicer.Timings, :with_dice, [1])
    IO.puts time
    {time, _} = :timer.tc(Dicer.Timings, :simple, [1])
    IO.puts time
  end

  def simple(times) do
    for _x <- 1..times do
      Dicer.roll("0.5")
    end
  end
  def same_string_compute(times) do
    for _x <- 1..times do
      Dicer.roll("(1-(33+(44-(3.45+(1.23+(8.1-(0.5)))))))")
    end
  end
  def with_dice(times) do
    for _x <- 1..times do
      Dicer.roll("400d33+300d5-515d1000")
    end
  end
end