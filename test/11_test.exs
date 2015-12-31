defmodule CorporatePolicyTest do
  use ExUnit.Case
  import CorporatePolicy
  doctest CorporatePolicy

  @moduletag :slow

  test "test case" do
    assert next_password("ghijklmn") == "ghjaabcc"
  end

  test "assignment 1" do
    assert next_password("vzbxkghb") == "vzbxxyzz"
  end

  test "assignment 2" do
    assert next_password("vzbxxyzz") == "vzcaabcc"
  end
end
