defmodule AllInASingleNight do
  defstruct [distances: %{}, locations: []]
  @moduledoc """
  --- Day 9: All in a Single Night ---

  Every year, Santa manages to deliver all of his presents in a single night.

  This year, however, he has some new locations to visit; his elves have
  provided him the distances between every pair of locations. He can start and
  end at any two (different) locations he wants, but he must visit each location
  exactly once. What is the shortest distance he can travel to achieve this?

  For example, given the following distances:

  London to Dublin = 464
  London to Belfast = 518
  Dublin to Belfast = 141

  The possible routes are therefore:

  Dublin -> London -> Belfast = 982
  London -> Dublin -> Belfast = 605
  London -> Belfast -> Dublin = 659
  Dublin -> Belfast -> London = 659
  Belfast -> Dublin -> London = 605
  Belfast -> London -> Dublin = 982

  The shortest of these is London -> Dublin -> Belfast = 605, and so the answer
  is 605 in this example.

  What is the distance of the shortest route?

  --- Part Two ---

  The next year, just to show off, Santa decides to take the route with the
  longest distance instead.

  He can still start and end at any two (different) locations he wants, and he
  still must visit each location exactly once.

  For example, given the distances above, the longest route would be 982 via
  (for example) Dublin -> London -> Belfast.

  What is the distance of the longest route?
  """

  @doc """
  ## Example
      iex> "London to Dublin = 464\\nLondon to Belfast = 518\\nDublin to Belfast = 141\\n" |> parse
      %AllInASingleNight{distances: %{{"Dublin", "London"} => 464, {"Belfast", "London"} => 518, {"Belfast", "Dublin"} => 141}, locations: ~w(Belfast Dublin London)}
  """
  def parse(input) do
    %__MODULE__{}
    |> parse_distances(input)
    |> parse_locations
  end

  defp key(from, to) do
    [from, to] |> Enum.sort |> List.to_tuple
  end

  defp value(struct, from, to) do
    struct.distances[key(from, to)]
  end

  defp parse_distances(struct, input) do
    %__MODULE__{struct | distances: Regex.scan(~r/(\w+) to (\w+) = (\d+)\n?/, input, capture: :all_but_first)
    |> Enum.map(fn([from, to, dist]) ->
      { key(from, to), String.to_integer(dist) }
    end)
    |> Enum.into(%{})}
  end

  defp parse_locations(struct) do
    %__MODULE__{struct | locations: Map.keys(struct.distances)
    |> Enum.map(&Tuple.to_list/1)
    |> List.flatten
    |> Enum.uniq}
  end

  @doc """
  ## Example
      iex> "London to Dublin = 464\\nLondon to Belfast = 518\\nDublin to Belfast = 141\\n" |> parse |> shortest
      {{"Belfast", "Dublin", "London"}, 605}
  """
  def shortest(struct) do
    routes([], struct.locations)
    |> Enum.map(&route_with_length(&1, struct))
    |> Enum.reduce(fn({_, dist} = curr, {_, min_dist} = min) ->
      if dist < min_dist do
        curr
      else
        min
      end
    end)
  end

  defp route_with_length(route, struct) do
    dist = route
    |> Tuple.to_list
    |> Enum.chunk(2, 1)
    |> Enum.reduce(0, fn([from, to], acc) ->
      acc + value(struct, from, to)
    end)
    {route, dist}
  end

  @doc """
  ## Example
      iex> "London to Dublin = 464\\nLondon to Belfast = 518\\nDublin to Belfast = 141\\n" |> parse |> longest
      {{"Belfast", "London", "Dublin"}, 982}
  """
  def longest(struct) do
    routes([], struct.locations)
    |> Enum.map(&route_with_length(&1, struct))
    |> Enum.reduce(fn({_, dist} = curr, {_, min_dist} = min) ->
      if dist > min_dist do
        curr
      else
        min
      end
    end)
  end

  defp routes(route, []) do
    route |> List.to_tuple
  end
  defp routes(route, dests) do
    dests
    |> Enum.map(fn(start) ->
      routes(route ++ [start], dests -- [start])
    end)
    |> List.flatten
  end
end

# London -> London
# London, Belfast
# Belfast, London
#
# London, Belfast, Dublin
# London, Dublin, Belfast
# Belfast, London, Dublin
# Belfast, Dublin, London
# Dublin, London, Belfast
# Dublin, Belfast, London
