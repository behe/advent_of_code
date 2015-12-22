defmodule TheIdealStockingStufferTest do
  use ExUnit.Case
  import TheIdealStockingStuffer
  doctest TheIdealStockingStuffer

  @tag :skip
  test "sample input" do
    assert "abcdef" |> advent_code_5_zeroes == 609043
    assert "pqrstuv" |> advent_code_5_zeroes == 1048970
  end

  @tag :skip
  test "assignment 1" do
    assert "iwrupvqb" |> advent_code_5_zeroes == 346386
  end

  @tag :skip
  test "assignment 2" do
    assert "iwrupvqb" |> advent_code_6_zeroes == 9958218
  end
end
