defmodule Dicer.Tokens do
  defmodule Plus do
    @representation ~r/\A\+/
    defstruct function: &(&1 + &2)

    def get_regex() do
      @representation
    end
  end

  defmodule Minus do
    @representation ~r/\A-/
    defstruct function: &(&1 - &2)

    def get_regex() do
      @representation
    end
  end

  defmodule Multiply do
    @representation ~r/\A\*/
    defstruct function: &(&1 * &2)

    def get_regex() do
      @representation
    end
  end

  defmodule Divide do
    @representation ~r/\A\//
    defstruct function: &(&1 / &2)

    def get_regex() do
      @representation
    end
  end

  defmodule LeftParenthesis do
    @representation ~r/\A\(/
    defstruct value: "("

    def get_regex() do
      @representation
    end
  end

  defmodule RightParenthesis do
    @representation ~r/\A\)/
    defstruct value: ")"

    def get_regex() do
      @representation
    end
  end

  defmodule TakeTop do
    @representation ~r/\A\^(\d+)/
    defstruct take_num: 0

    def get_regex() do
      @representation
    end
  end

  defmodule TakeBottom do
    @representation ~r/\Av(\d+)/
    defstruct take_num: 0

    def get_regex() do
      @representation
    end
  end

  defmodule Dice do
    @representation ~r/\A(\d*)[dD](\d+)/
    defstruct quantity: 0, sides: 1, counted_values: [], rejected_values: [], raw_rolls: []

    def get_regex() do
      @representation
    end
  end

  defmodule FudgeDice do
    @representation ~r/\A(\d*)[dD][fF]/
    defstruct quantity: 0, sides: 3, counted_values: [], rejected_values: [], raw_rolls: []

    def get_regex() do
      @representation
    end
  end

  defmodule Num do
    @representation ~r/\A(\d*)(\.)*(\d+)/
    defstruct value: nil

    def convert_to_float(input = %Num{}) do
      {num_val, _} = Float.parse(input.value)

      Float.round(num_val,4)
    end

    def get_regex() do
      @representation
    end
  end

  defmodule End do
    @representation ~r/\A\z/
    defstruct value: ""

    def get_regex() do
      @representation
    end
  end
end