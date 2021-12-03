defmodule AdventOfCode.Day3Test do
  use ExUnit.Case

  test "compute power consumption" do
    assert AdventOfCode.Day3.compute_power_consumption() === 841526
  end

end
