defmodule AdventOfCode.Day3 do

  require Logger

  def compute_power_consumption() do
    {gama_bits, epsilon_bits} =
      get_input("day_3_input.txt")
      |> Enum.reduce([], fn bit_values, acc ->
        bit_values
        |> Enum.with_index
        |> Enum.map(fn {value, index} ->
          [count_0, count_1] = Enum.at(acc, index, [0, 0])
          [
            (if value == 0, do: count_0 + 1, else: count_0),
            (if value == 1, do: count_1 + 1, else: count_1),
          ]
        end)
      end)
      |> Enum.reduce([], fn [count_0, count_1], acc ->
        Enum.concat(acc, [
          {
            # The gama rate in binary
            (if count_0 > count_1, do: 0, else: 1),
            # The epsilon rate in binary (Just the oposite of the gama rate)
            (if count_0 > count_1, do: 1, else: 0),
          }
        ])
      end)
      |> Enum.reduce({"", ""}, fn {gama_bit, epsilon_bit}, {game_str, epsilon_str} ->
        {
          game_str <> to_string(gama_bit),
          epsilon_str <> to_string(epsilon_bit)
        }
      end)

      {{gama, _}, {epsilon, _}} = { Integer.parse(gama_bits, 2), Integer.parse(epsilon_bits, 2) }

      gama * epsilon
  end


  # Parse input contents from file
  defp get_input(filename) do
    file_path = Path.join(:code.priv_dir(:adventofcode2021), filename)
    {:ok, content} = File.read(file_path)
    content
    |> String.split("\n", trim: true)
    |> Stream.map(fn str ->
      String.split(str, "", trim: true)
    end)
    |> Enum.map(fn bit_list ->
      Enum.map(bit_list, fn bit ->
        {bit_in_int, _} = Integer.parse(bit)
        bit_in_int
      end)
    end)
  end

end
