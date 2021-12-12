defmodule AdventOfCode.Day4 do
  require Logger

  def get_score() do
    {input, grids} = get_input("day_4_input.txt")
  end

  # Parse input contents from file
  defp get_input(filename) do
    file_path = Path.join(:code.priv_dir(:adventofcode2021), filename)
    {:ok, content} = File.read(file_path)

    input_numbers =
      content
      |> String.split("\n", trim: true)
      |> Enum.take(1)
      |> Enum.map(fn str ->
        String.split(str, ",", trim: true)
      end)
      |> List.flatten()
      |> Enum.map(fn numStr ->
        {num, _} = Integer.parse(numStr)
        num
      end)

    grids =
      content
      |> String.split("\n", trim: true)
      # Skip input numbers and empty line
      |> Enum.drop(1)
      |> Enum.reduce([], fn str_line, acc ->
        Logger.debug("Line to parse: #{str_line}")

        case String.length(str_line) do
          0 ->
            acc

          _ ->
            case length(acc) do
              0 ->
                grid = BingoGrid.init()
                [BingoGrid.expand_grid(grid, str_line)]

              _ ->
                [grid | rest] = acc

                if BingoGrid.is_grid_incomplete?(grid) do
                  [BingoGrid.expand_grid(grid, str_line) | rest]
                else
                  grid = BingoGrid.init()
                  [BingoGrid.expand_grid(grid, str_line) | acc]
                end
            end
        end
      end)

    {input_numbers, grids}
  end
end

defmodule BingoNumber do
  @enforce_keys [:value]
  defstruct value: nil, checked: false

  @type t() :: %__MODULE__{
          value: non_neg_integer(),
          checked: boolean()
        }

  def init(value) do
    %__MODULE__{value: value, checked: false}
  end
end

defmodule BingoGrid do
  @grid_max_rows 5
  @grid_max_cols 5

  defstruct numbers: [], did_win: false

  @type t() :: %__MODULE__{
          numbers: nonempty_list(BingoNumber.t()),
          did_win: boolean()
        }

  def init() do
    %__MODULE__{numbers: [], did_win: false}
  end

  def is_grid_incomplete?(%BingoGrid{} = grid) do
    case length(grid.numbers) do
      0 -> true
      len when len < @grid_max_cols * @grid_max_rows -> true
      _ -> false
    end
  end

  def expand_grid(%BingoGrid{} = grid, str) do
    numbers =
      str
      |> String.split(" ", trim: true)
      |> Enum.filter(fn v -> v != " " end)
      |> Enum.map(fn v ->
        {num, _} = Integer.parse(v)
        BingoNumber.init(num)
      end)

    %__MODULE__{numbers: grid.numbers ++ numbers}
  end

  def grid_row_size() do
    @grid_max_rows
  end
end

defimpl String.Chars, for: BingoGrid do
  def to_string(grid) do
    # Just print the grid in the same way
    # it was formatted within the input file
    result =
      grid.numbers
      |> Enum.with_index()
      |> Enum.reduce("", fn {n, index}, acc ->
        case rem(index, BingoGrid.grid_row_size()) do
          0 when acc == "" ->
            "#{n.value}"

          0 when index == 0 ->
            "#{n.value}"

          0 ->
            "#{acc}\n#{n.value}"

          _ ->
            "#{acc}, #{n.value}"
        end
      end)

    "\n#{result}"
  end
end
