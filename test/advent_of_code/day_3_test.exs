defmodule AdventOfCode.Day3Test do
  use ExUnit.Case

  test "compute power consumption" do
    # Demo input
    # assert AdventOfCode.Day3.compute_power_consumption() == 198
    assert AdventOfCode.Day3.compute_power_consumption() == 841_526
  end

  test "compute life support" do
    # Demo input
    # assert AdventOfCode.Day3.compute_life_support() == 230
    assert AdventOfCode.Day3.compute_life_support() == 47_903_90
  end
end
