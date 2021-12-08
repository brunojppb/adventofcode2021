defmodule AdventOfCode.Day4 do

  require Logger

  def get_score() do
    input = get_input("day_4_input.txt")
    Logger.debug("Values #{inspect(input)}")
  end

  # Parse input contents from file
  defp get_input(filename) do
    file_path = Path.join(:code.priv_dir(:adventofcode2021), filename)
    {:ok, content} = File.read(file_path)

    content
    |> String.split("\n", trim: true)
    |> Enum.take(1)
    |> Enum.map(fn str ->
      String.split(str, ",", trim: true)
    end)
    |> List.flatten
    |> Enum.map(fn numStr ->
      {num, _} = Integer.parse(numStr)
      num
    end)
  end

end

defmodule BingoNumber do

  @enforce_keys [:value]
  defstruct value: nil, checked: false

  @type t() :: %__MODULE__{
    value: non_neg_integer(),
    checked: boolean()
  }

end

defmodule BingoGrid do

  defstruct numbers: []

  @type t() :: %__MODULE__{
    numbers: nonempty_list(BingoNumber.t())
  }

  def expandGrid(%BingoGrid{} = grid, numbers) do
    %BingoGrid{
      numbers: grid.numbers ++ Enum.map(numbers, fn n -> %BingoNumber{value: n, checked: false} end)
    }
  end

end
