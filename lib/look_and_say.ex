defmodule LookAndSay do
  @moduledoc """
  --- Day 10: Elves Look, Elves Say ---

  Today, the Elves are playing a game called look-and-say. They take turns
  making sequences by reading aloud the previous sequence and using that reading
  as the next sequence. For example, 211 is read as "one two, two ones", which
  becomes 1221 (1 2, 2 1s).

  Look-and-say sequences are generated iteratively, using the previous value as
  input for the next step. For each step, take the previous value, and replace
  each run of digits (like 111) with the number of digits (3) followed by the
  digit itself (1).

  For example:

  1 becomes 11 (1 copy of digit 1).
  11 becomes 21 (2 copies of digit 1).
  21 becomes 1211 (one 2 followed by one 1).
  1211 becomes 111221 (one 1, one 2, and two 1s).
  111221 becomes 312211 (three 1s, two 2s, and one 1).

  Starting with the digits in your puzzle input, apply this process 40 times.
  What is the length of the result?

  Your puzzle input is 1113222113.

  --- Part Two ---

  Neat, right? You might also enjoy hearing John Conway talking about this
  sequence (that's Conway of Conway's Game of Life fame).

  Now, starting again with the digits in your puzzle input, apply this process
  50 times. What is the length of the new result?
  """

  @doc """
  ## Example
      iex> "1" |> next_sequence
      "11"
  """
  def next_sequence(input) do
    input
    |> String.codepoints
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_by(&(&1))
    |> Enum.map(&[Enum.count(&1), &1 |> List.first])
    |> List.flatten
    |> Enum.join
  end

  @doc """
  ## Example
      iex> "1" |> sequence(0)
      "1"

      iex> "1" |> sequence(1)
      "11"

      iex> "1" |> sequence(2)
      "21"

      iex> "1" |> sequence(3)
      "1211"

      iex> "1" |> sequence(4)
      "111221"

      iex> "1" |> sequence(5)
      "312211"
  """
  def sequence(input, 0), do: input
  def sequence(input, n) do
    sequence(next_sequence(input), n - 1)
  end
end
