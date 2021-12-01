defmodule AdventOfCode.Day1Test do
  use ExUnit.Case

  test "detects how many measurements are larger than the previous measurement" do
    file_path = Path.join(:code.priv_dir(:adventofcode2021), "day_1_input.txt")
    {:ok, input} = File.read(file_path)
    assert AdventOfCode.Day1.detect_measurements([]) === 10
  end
end
