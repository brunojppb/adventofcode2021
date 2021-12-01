defmodule AdventOfCode.Day1Test do
  use ExUnit.Case

  test "detects how many measurements are larger than the previous measurement" do
    assert AdventOfCode.Day1.detect_measurements() === 1665
  end
end
