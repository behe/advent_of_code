defmodule JSAbacusFrameworkTest do
  use ExUnit.Case
  import JSAbacusFramework
  doctest JSAbacusFramework

  test "assignment 1" do
    assert File.read!("test/fixtures/12.txt") |> extract_numbers |> Enum.sum
    == 119433
  end

  test "assignment 2" do
    assert File.read!("test/fixtures/12.txt") |> extract_non_red_numbers |> Enum.sum
    == 68466
  end
end
