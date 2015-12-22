defmodule ProbablyAFireHazardTest do
  use ExUnit.Case
  import ProbablyAFireHazard
  doctest ProbablyAFireHazard

  @tag :slow
  test "assignment 1" do
    assert File.read!("test/fixtures/6.txt")
    |> parse
    |> play
    |> count == 377891
  end

  @tag :slow
  test "assignment 2" do
    assert File.read!("test/fixtures/6.txt")
    |> parse
    |> play_brightness
    |> count == 14110788
  end
end
