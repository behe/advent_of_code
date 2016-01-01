defmodule KnightsOfTheDinnerTableTest do
  use ExUnit.Case
  import KnightsOfTheDinnerTable
  doctest KnightsOfTheDinnerTable

  test "test case" do
    assert """
    Alice would gain 54 happiness units by sitting next to Bob.
    Alice would lose 79 happiness units by sitting next to Carol.
    Alice would lose 2 happiness units by sitting next to David.
    Bob would gain 83 happiness units by sitting next to Alice.
    Bob would lose 7 happiness units by sitting next to Carol.
    Bob would lose 63 happiness units by sitting next to David.
    Carol would lose 62 happiness units by sitting next to Alice.
    Carol would gain 60 happiness units by sitting next to Bob.
    Carol would gain 55 happiness units by sitting next to David.
    David would gain 46 happiness units by sitting next to Alice.
    David would lose 7 happiness units by sitting next to Bob.
    David would gain 41 happiness units by sitting next to Carol.
    """
    |> parse |> best_arrangement |> elem(1) == 330
  end

  test "assignment 1" do
    assert parse(File.read!("test/fixtures/13.txt")) |> best_arrangement |> elem(1)
    == 709
  end

  test "assignment 2" do
    relations = parse(File.read!("test/fixtures/13.txt"))
    people = people(relations)
    relations = Enum.reduce(people, relations, fn(person, acc) ->
      put_in acc, [key(person, "Me")], 0
    end)
    assert relations |> best_arrangement |> elem(1)
    == 668
  end
end
