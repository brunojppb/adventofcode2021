defmodule AdventOfCode.Day1 do
  require Logger

  def measure_check() do
    {count, _} =
      get_input("day_1_input.txt")
      |> Enum.reduce({0, nil}, fn nextMeasurement, acc ->
        case acc do
          # No measurements before the first one
          {0, nil} ->
            {0, nextMeasurement}

          # Only bump the count if there was an actual increase in the measurement
          {count, lastMeasurement} ->
            nextCount = if nextMeasurement > lastMeasurement, do: count + 1, else: count
            {nextCount, nextMeasurement}
        end
      end)

    count
  end

  def sliding_window_check() do
    list_of_numbers = get_input("day_1_input.txt")

    list_of_numbers
    |> Enum.with_index()
    |> Enum.reduce(0, fn {_, index}, sum ->
      jump_index = index + 2

      case Enum.at(list_of_numbers, jump_index + 1) do
        value when value != nil ->
          prev_window =
            Enum.at(list_of_numbers, jump_index - 2) + Enum.at(list_of_numbers, jump_index - 1) +
              Enum.at(list_of_numbers, jump_index)

          next_window =
            Enum.at(list_of_numbers, jump_index - 1) + Enum.at(list_of_numbers, jump_index) +
              Enum.at(list_of_numbers, jump_index + 1)

          if next_window > prev_window, do: sum + 1, else: sum

        _ ->
          sum
      end
    end)
  end

  # Parse input contents from file
  defp get_input(filename) do
    file_path = Path.join(:code.priv_dir(:adventofcode2021), filename)
    {:ok, content} = File.read(file_path)

    content
    |> String.split("\n", trim: true)
    |> Enum.map(fn str ->
      {num, _} = Integer.parse(str)
      num
    end)
  end
end
