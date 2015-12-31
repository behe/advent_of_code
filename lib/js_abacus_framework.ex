defmodule JSAbacusFramework do
  @moduledoc """
  --- Day 12: JSAbacusFramework.io ---

  Santa's Accounting-Elves need help balancing the books after a recent order.
  Unfortunately, their accounting software uses a peculiar storage format.
  That's where you come in.

  They have a JSON document which contains a variety of things: arrays
  ([1,2,3]), objects ({"a":1, "b":2}), numbers, and strings. Your first job is
  to simply find all of the numbers throughout the document and add them
  together.

  For example:

  [1,2,3] and {"a":2,"b":4} both have a sum of 6.
  [[[3]]] and {"a":{"b":4},"c":-1} both have a sum of 3.
  {"a":[-1,1]} and [-1,{"a":1}] both have a sum of 0.
  [] and {} both have a sum of 0.

  You will not encounter any strings containing numbers.

  What is the sum of all numbers in the document?

  --- Part Two ---

  Uh oh - the Accounting-Elves have realized that they double-counted everything
  red.

  Ignore any object (and all of its children) which has any property with the
  value "red". Do this only for objects ({...}), not arrays ([...]).

  [1,2,3] still has a sum of 6.
  [1,{"c":"red","b":2},3] now has a sum of 4, because the middle object is
  ignored.
  {"d":"red","e":[1,2,3,4],"f":5} now has a sum of 0, because the entire
  structure is ignored.
  [1,"red",5] has a sum of 6, because "red" in an array has no effect.
  """

  @doc """
  [1,2,3] and {"a":2,"b":4} both have a sum of 6.
  [[[3]]] and {"a":{"b":4},"c":-1} both have a sum of 3.
  {"a":[-1,1]} and [-1,{"a":1}] both have a sum of 0.
  [] and {} both have a sum of 0.

  ## Example
      iex> "[1,2,3]" |> extract_numbers |> Enum.sum
      6

      iex> "{\\"a\\":2,\\"b\\":4}" |> extract_numbers |> Enum.sum
      6

      iex> "[[[3]]]" |> extract_numbers |> Enum.sum
      3

      iex> "{\\"a\\":{\\"b\\":4}, \\"c\\":-1}" |> extract_numbers |> Enum.sum
      3

      iex> "{\\"a\\":[-1,1]}" |> extract_numbers |> Enum.sum
      0

      iex> "[-1, {\\"a\\":1}]" |> extract_numbers |> Enum.sum
      0

      iex> "[]" |> extract_numbers |> Enum.sum
      0

      iex> "{}" |> extract_numbers |> Enum.sum
      0
  """
  def extract_numbers(input) do
    Regex.scan(~r/(-?\d+)/, input, capture: :all_but_first)
    |> List.flatten
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  [1,2,3] still has a sum of 6.
  [1,{"c":"red","b":2},3] now has a sum of 4, because the middle object is
  ignored.
  {"d":"red","e":[1,2,3,4],"f":5} now has a sum of 0, because the entire
  structure is ignored.
  [1,"red",5] has a sum of 6, because "red" in an array has no effect.

  ## Example
      iex> "[1,2,3]" |> extract_non_red_numbers |> Enum.sum
      6

      iex> "[{\\"a\\":1},{\\"c\\":\\"red\\",\\"b\\":2},3]" |> extract_non_red_numbers |> Enum.sum
      4

      iex> "{\\"d\\":\\"red\\",\\"e\\":[1,2,3,4],\\"f\\":5}" |> extract_non_red_numbers |> Enum.sum
      0

      iex> "[1, \\"red\\", 5]" |> extract_non_red_numbers |> Enum.sum
      6
  """
  def extract_non_red_numbers(input) do
    Poison.decode!(input)
    |> filter([])
  end

  def filter(e, acc) when is_integer(e), do: [e | acc]
  def filter({_, e}, acc), do: filter(e, acc)
  def filter(e, acc) when is_list(e) do
    acc ++ Enum.reduce(e, [], &filter/2)
  end
  def filter(e, acc) when is_map(e) do
    cond do
      "red" in Map.values(e) -> acc
      :else -> acc ++ Enum.reduce(e, [], &filter/2)
    end
  end
  def filter(_, acc), do: acc
end
