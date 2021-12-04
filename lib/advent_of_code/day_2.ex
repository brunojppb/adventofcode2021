defmodule AdventOfCode.Day2 do
  def compute_position() do
    {position, depth} =
      get_input("day_2_input.txt")
      |> Enum.reduce({0, 0}, fn {command, value}, {position, depth} ->
        case command do
          "forward" ->
            {position + value, depth}

          "down" ->
            {position, depth + value}

          "up" ->
            {position, depth - value}
        end
      end)

    position * depth
  end

  def compute_position_with_aim() do
    {position, depth, _} =
      get_input("day_2_input.txt")
      |> Enum.reduce({0, 0, 0}, fn {command, value}, {position, depth, aim} ->
        case command do
          "forward" ->
            {position + value, depth + aim * value, aim}

          "down" ->
            {position, depth, aim + value}

          "up" ->
            {position, depth, aim - value}
        end
      end)

    position * depth
  end

  # Parse input contents from file
  defp get_input(filename) do
    file_path = Path.join(:code.priv_dir(:adventofcode2021), filename)
    {:ok, content} = File.read(file_path)

    content
    |> String.split("\n", trim: true)
    |> Enum.map(fn str ->
      [command, value] = String.split(str)
      {num, _} = Integer.parse(value)
      {command, num}
    end)
  end
end
