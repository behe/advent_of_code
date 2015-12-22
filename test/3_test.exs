defmodule PerfectlySphericalHousesInAVacuumTest do
  use ExUnit.Case
  import PerfectlySphericalHousesInAVacuum
  doctest PerfectlySphericalHousesInAVacuum

  test "assignment 1" do
    assert File.read!("test/fixtures/3.txt")
    |> unique_houses
    == 2572
  end

  test "assignment 2" do
    assert File.read!("test/fixtures/3.txt")
    |> robo_unique_houses
    == 2631
  end
end
