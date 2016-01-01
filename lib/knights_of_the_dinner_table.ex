defmodule KnightsOfTheDinnerTable do
  @defmodule """
  --- Day 13: Knights of the Dinner Table ---

  In years past, the holiday feast with your family hasn't gone so well. Not
  everyone gets along! This year, you resolve, will be different. You're going
  to find the optimal seating arrangement and avoid all those awkward
  conversations.

  You start by writing up a list of everyone invited and the amount their
  happiness would increase or decrease if they were to find themselves sitting
  next to each other person. You have a circular table that will be just big
  enough to fit everyone comfortably, and so each person will have exactly two
  neighbors.

  For example, suppose you have only four attendees planned, and you calculate
  their potential happiness as follows:

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

  Then, if you seat Alice next to David, Alice would lose 2 happiness units
  (because David talks so much), but David would gain 46 happiness units
  (because Alice is such a good listener), for a total change of 44.

  If you continue around the table, you could then seat Bob next to Alice (Bob
  gains 83, Alice gains 54). Finally, seat Carol, who sits next to Bob (Carol
  gains 60, Bob loses 7) and David (Carol gains 55, David gains 41). The
  arrangement looks like this:

       +41 +46
  +55   David    -2
  Carol       Alice
  +60    Bob    +54
       -7  +83

  After trying every other seating arrangement in this hypothetical scenario,
  you find that this one is the most optimal, with a total change in happiness
  of 330.

  What is the total change in happiness for the optimal seating arrangement of
  the actual guest list?

  --- Part Two ---

  In all the commotion, you realize that you forgot to seat yourself. At this
  point, you're pretty apathetic toward the whole thing, and your happiness
  wouldn't really go up or down regardless of who you sit next to. You assume
  everyone else would be just as ambivalent about sitting next to you, too.

  So, add yourself to the list, and give all happiness relationships that
  involve you a score of 0.

  What is the total change in happiness for the optimal seating arrangement that
  actually includes yourself?
  """

  @doc """
  ## Example
      iex> "Alice would lose 2 happiness units by sitting next to David.
      ...> David would gain 46 happiness units by sitting next to Alice." |> parse
      %{{"Alice", "David"} => 44}
  """
  def parse(input) do
    Regex.scan(~r/(\w+) would (lose|gain) (\d+) .* to (\w+)\./, input, capture: :all_but_first)
    |> Enum.reduce(%{}, fn([x, sign, points, y], acc) ->
      update_in acc, [[x,y] |> Enum.sort |> List.to_tuple], fn(last) ->
         points = String.to_integer(points)
         sign = if sign == "gain", do: 1, else: -1
         last = last || 0
         (points * sign) + last
       end
    end)
  end

  def people(relations) do
    relations |> Enum.flat_map(&elem(&1, 0) |> Tuple.to_list) |> Enum.uniq
  end

  def best_arrangement(relations) do
    arrangements([], people(relations))
    |> Enum.map(&arrangement_with_score(&1, relations))
    |> Enum.sort_by(&elem(&1, 1))
    |> List.last
  end

  defp arrangement_with_score(route, relations) do
    dist = route
    |> Tuple.to_list
    |> Enum.chunk(2, 1)
    |> Enum.reduce(0, fn([from, to], acc) ->
      acc + value(relations, from, to)
    end)
    {route, dist}
  end

  def key(x, y) do
    [x, y] |> Enum.sort |> List.to_tuple
  end

  defp value(relations, x, y) do
    relations[key(x, y)]
  end

  defp arrangements(arrangement, []) do
    (arrangement ++ [List.first(arrangement)]) |> List.to_tuple
  end
  defp arrangements(arrangement, people) do
    people
    |> Enum.map(fn(start) ->
      arrangements(arrangement ++ [start], people -- [start])
    end)
    |> List.flatten
  end
end
