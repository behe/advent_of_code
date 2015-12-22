defmodule IWasToldThereWouldBeNoMathTest do
  use ExUnit.Case
  import IWasToldThereWouldBeNoMath
  doctest IWasToldThereWouldBeNoMath

  test "assignment 1" do
    assert File.read!("test/fixtures/2.txt")
    |> paper
    == 1598415
  end

  test "assignment 2" do
    assert File.read!("test/fixtures/2.txt")
    |> ribbon
    == 3812909
  end
end
