defmodule AdventOfCode.Day2Test do
  use ExUnit.Case

  test "compute submarine position" do
    assert AdventOfCode.Day2.compute_position() === 1855814
  end

  test "compute submarine position with aim" do
    assert AdventOfCode.Day2.compute_position_with_aim() === 1845455714
  end

end
