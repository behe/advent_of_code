defmodule SomeAssemblyRequiredTest do
  use ExUnit.Case
  import SomeAssemblyRequired
  doctest SomeAssemblyRequired

  test "assignment 1" do
    assert File.read!("test/fixtures/7.txt")
    |> parse
    |> find_value(["a"]) == [46065]
  end

  test "assignment 2" do
    assert File.read!("test/fixtures/7.txt")
    |> parse
    |> put_in(["b"], %{args: 46065, operation: :assign})
    |> find_value(["a"]) == [14134]
  end
end
