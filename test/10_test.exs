defmodule LookAndSayTest do
  use ExUnit.Case
  import LookAndSay
  doctest LookAndSay

  @tag :slow
  test "assignment 1" do
    assert sequence("1113222113", 40) |> String.length == 252594
  end

  @tag :slow
  test "assignment 2" do
    assert sequence("1113222113", 50) |> String.length == 3579328
  end
end
