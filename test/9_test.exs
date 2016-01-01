defmodule AllInASingleNightTest do
  use ExUnit.Case
  import AllInASingleNight
  doctest AllInASingleNight

  test "assignment 1" do
    assert File.read!("test/fixtures/9.txt")
    |> parse |> shortest
     == {{"Norrath", "Straylight", "Arbre", "Faerun", "AlphaCentauri", "Snowdin", "Tambi", "Tristram"}, 207}
  end

  test "assignment 2" do
    assert File.read!("test/fixtures/9.txt")
    |> parse |> longest
     == {{"Tambi", "Faerun", "Norrath", "Tristram", "AlphaCentauri", "Arbre", "Snowdin", "Straylight"}, 804}
  end
end
