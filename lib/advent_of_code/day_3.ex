defmodule AdventOfCode.Day3 do
  require Logger

  def compute_power_consumption() do
    {gama_bits, epsilon_bits} =
      get_input("day_3_input.txt")
      |> count_bit_occurencies
      # Now compute the game rate based on the occurencies of
      # '0's and '1' within each binary value
      |> Enum.reduce([], fn [count_0, count_1], acc ->
        Enum.concat(acc, [
          {
            # The gama rate in binary
            if(count_0 > count_1, do: 0, else: 1),
            # The epsilon rate in binary (Just the oposite of the gama rate)
            if(count_0 > count_1, do: 1, else: 0)
          }
        ])
      end)
      |> Enum.reduce({"", ""}, fn {gama_bit, epsilon_bit}, {game_str, epsilon_str} ->
        {
          game_str <> to_string(gama_bit),
          epsilon_str <> to_string(epsilon_bit)
        }
      end)

    {gama, _} = Integer.parse(gama_bits, 2)
    {epsilon, _} = Integer.parse(epsilon_bits, 2)

    gama * epsilon
  end

  def compute_life_support() do
    oxygen_rating = life_support_check(fn bit, a, b -> oxygen_level_check(bit, a, b) end)
    co2_rating = life_support_check(fn bit, a, b -> co2_scrubber_rating_check(bit, a, b) end)
    oxygen_rating * co2_rating
  end

  defp life_support_check(metric_checker_fn) do
    input = get_input("day_3_input.txt")

    {oxygen_rating, _} =
      input
      |> Enum.reduce_while({input, 0}, fn _, {reduced_list, reductions} ->
        occur = count_bit_occurencies(reduced_list)
        [count_0, count_1] = Enum.at(occur, reductions)

        result =
          reduced_list
          |> Enum.filter(fn bit_sequence ->
            current_bit = Enum.at(bit_sequence, reductions)
            metric_checker_fn.(current_bit, count_0, count_1)
          end)

        case result do
          [last_value] -> {:halt, last_value}
          [] -> {:halt, :error}
          _ -> {:cont, {result, reductions + 1}}
        end
      end)
      |> List.flatten()
      |> Enum.join()
      |> Integer.parse(2)

    oxygen_rating
  end

  defp oxygen_level_check(bit, count_0, count_1) do
    case bit do
      _ when count_0 == count_1 -> bit == 1
      _ when count_0 > count_1 -> bit == 0
      _ when count_0 < count_1 -> bit == 1
    end
  end

  defp co2_scrubber_rating_check(bit, count_0, count_1) do
    case bit do
      _ when count_0 == count_1 -> bit == 0
      _ when count_0 > count_1 -> bit == 1
      _ when count_0 < count_1 -> bit == 0
    end
  end

  defp count_bit_occurencies(bit_list) do
    # Count the most common bit across the second dimention of the
    # input matrix. E.g. for the following input:
    # 011010010110
    # 111110100110
    # 011011011110
    # 100011010001
    # '0' appears 2x and '1' appears 2x on the first column
    # '0' appears 1x and '1' appears 3x on the first column
    bit_list
    |> Enum.reduce([], fn bit_values, acc ->
      bit_values
      |> Enum.with_index()
      |> Enum.map(fn {value, index} ->
        [count_0, count_1] = Enum.at(acc, index, [0, 0])

        [
          if(value == 0, do: count_0 + 1, else: count_0),
          if(value == 1, do: count_1 + 1, else: count_1)
        ]
      end)
    end)
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
