defmodule ProbablyAFireHazardTest do
  use ExUnit.Case
  import ProbablyAFireHazard
  doctest ProbablyAFireHazard

  @moduletag :slow

  test "toggle all" do
    assert "toggle 0,0 through 999,999" |> parse |> play_brightness |> count
    == 2_000_000
  end

  test "turn on 0,0 through 999,999" do
    assert"turn on 0,0 through 999,999" |> parse |> play |> count
    == 1_000_000
  end

  test "turn on 0,0 through 999,999 and toggle 0,0 through 999,0" do
    assert "turn on 0,0 through 999,999\ntoggle 0,0 through 999,0" |> parse |> play |> count
    == 999_000
  end

  test "turn on 0,0 through 999,999 and turn off 499,499 through 500,500" do
    assert "turn on 0,0 through 999,999\nturn off 499,499 through 500,500" |> parse |> play |> count
    == 999_996
  end

  test "assignment 1" do
    assert File.read!("test/fixtures/6.txt")
    |> parse
    |> play
    |> count == 377891
  end

  test "assignment 2" do
    assert File.read!("test/fixtures/6.txt")
    |> parse
    |> play_brightness
    |> count == 14110788
  end
end
