defmodule AdventOfCode.Day1Test do
  use ExUnit.Case

  test "detects how many measurements are larger" do
    assert AdventOfCode.Day1.measure_check() === 1665
  end

  test "detects how many sliding window measurements are larger" do
    assert AdventOfCode.Day1.sliding_window_check() === 1702
  end
end
