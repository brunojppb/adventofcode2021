defmodule AdventOfCode.Day1 do

  def detect_measurements() do

    {count, _} = get_input()
    |> String.split("\n", trim: true)
    |> Enum.map(fn str ->
      {num, _} = Integer.parse(str)
      num
    end)
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

  defp get_input() do
    file_path = Path.join(:code.priv_dir(:adventofcode2021), "day_1_input.txt")
    {:ok, content} = File.read(file_path)
    content
  end

end
