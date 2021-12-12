defmodule AdventOfCode.Day4Test do
  use ExUnit.Case

  test "check bingo score" do
    # Demo input
    # assert AdventOfCode.Day3.compute_power_consumption() == 198
    assert AdventOfCode.Day4.get_score() == 4512
  end
end
