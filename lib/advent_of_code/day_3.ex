defmodule AdventOfCode.Day3 do
  require Logger

  def compute_power_consumption() do
    {gama_bits, epsilon_bits} =
      get_input("day_3_input.txt")
      |> count_bit_occurencies
      # Now compute the game rate based on the occurencies of
      # '0's and '1' within each binary value
      |> Enum.reduce([], fn [count_zeros, count_ones], acc ->
        Enum.concat(acc, [
          {
            # The gama rate in binary
            if(count_zeros > count_ones, do: 0, else: 1),
            # The epsilon rate in binary (Just the oposite of the gama rate)
            if(count_zeros > count_ones, do: 1, else: 0)
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
    oxygen_rating = life_support_check(&__MODULE__.oxygen_level_check/3)
    co2_rating = life_support_check(&__MODULE__.co2_scrubber_rating_check/3)
    oxygen_rating * co2_rating
  end

  defp life_support_check(bit_metric_checker) do
    input = get_input("day_3_input.txt")

    {oxygen_rating, _} =
      input
      |> Enum.reduce_while({input, 0}, fn _, {reduced_list, reductions} ->
        occur = count_bit_occurencies(reduced_list)
        [count_zeros, count_ones] = Enum.at(occur, reductions)

        reduced_list
        |> Enum.filter(fn bit_sequence ->
          current_bit = Enum.at(bit_sequence, reductions)
          bit_metric_checker.(current_bit, count_zeros, count_ones)
        end)
        |> case do
          [last_value] -> {:halt, last_value}
          [] -> {:halt, :error}
          resulting_list -> {:cont, {resulting_list, reductions + 1}}
        end
      end)
      |> List.flatten()
      |> Enum.join()
      |> Integer.parse(2)

    oxygen_rating
  end

  def oxygen_level_check(bit, count_zeros, count_ones) do
    case bit do
      _ when count_zeros == count_ones -> bit == 1
      _ when count_zeros > count_ones -> bit == 0
      _ when count_zeros < count_ones -> bit == 1
    end
  end

  # Checking for the CO2 Scrubber rating is
  # just the complete oposite of checking Oxygen levels
  def co2_scrubber_rating_check(bit, count_zeros, count_ones) do
    !oxygen_level_check(bit, count_zeros, count_ones)
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
        [count_zeros, count_ones] = Enum.at(acc, index, [0, 0])

        [
          if(value == 0, do: count_zeros + 1, else: count_zeros),
          if(value == 1, do: count_ones + 1, else: count_ones)
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
