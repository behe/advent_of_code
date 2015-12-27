defmodule MatchsticksTest do
  use ExUnit.Case
  import Matchsticks
  doctest Matchsticks

  test "assignment 1" do
    assert File.read!("test/fixtures/8.txt")
    |> decoded_diff == 1350
  end

  test "assignment 2" do
    assert File.read!("test/fixtures/8.txt")
    |> encoded_diff == 2085
  end
end
