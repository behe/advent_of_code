defmodule ReindeerOlympicsTest do
  use ExUnit.Case
  import ReindeerOlympics
  doctest ReindeerOlympics

  test "test case" do
    assert """
    Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
    Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
    """
    |> parse |> at(1000) |> Enum.map(&elem(&1, 1)) |> Enum.max == 1120
  end

  test "assignment 1" do
    assert File.read!("test/fixtures/14.txt")
    |> parse |> at(2503) |> Enum.map(&elem(&1, 1)) |> Enum.max == 2640
  end

  test "assignment 2" do
    assert File.read!("test/fixtures/14.txt")
    |> parse |> scores(2503) |> Enum.map(&elem(&1, 1)) |> Enum.max == 1102
  end
end
