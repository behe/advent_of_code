defmodule NotQuiteLispTest do
  use ExUnit.Case
  import NotQuiteLisp
  doctest NotQuiteLisp

  test "assignment 1" do
    assert File.read!("test/fixtures/1.txt")
    |> lift_diff
    == 138
  end

  test "assignment 2" do
    assert File.read!("test/fixtures/1.txt")
    |> lift_pos(-1)
    == 1771
  end
end
