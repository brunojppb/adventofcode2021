defmodule AdventOfCode.Day2Test do
  use ExUnit.Case

  test "compute submarine position" do
    assert AdventOfCode.Day2.compute_position() === 1_855_814
  end

  test "compute submarine position with aim" do
    assert AdventOfCode.Day2.compute_position_with_aim() === 1_845_455_714
  end
end
