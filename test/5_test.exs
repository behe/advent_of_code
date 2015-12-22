defmodule DoesntHeHaveInternElvesForThisTest do
  use ExUnit.Case
  import DoesntHeHaveInternElvesForThis
  doctest DoesntHeHaveInternElvesForThis

  test "assignment 1" do
    assert File.read!("test/fixtures/5.txt")
    |> nice_count(&nice?/1) == 238
  end

  test "assignment 2" do
    assert File.read!("test/fixtures/5.txt")
    |> nice_count(&new_nice?/1) == 69
  end
end
