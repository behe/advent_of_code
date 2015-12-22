defmodule NotQuiteLisp do

  @doc """
  Santa is trying to deliver presents in a large apartment building, but he
  can't find the right floor - the directions he got are a little confusing. He
  starts on the ground floor (floor `0`) and then follows the instructions one
  character at a time.

  An opening parenthesis, `(`, means he should go up one floor, and a closing
  parenthesis, `)`, means he should go down one floor.

  The apartment building is very tall, and the basement is very deep; he will
  never find the top or bottom floors.

  To `what floor` do the instructions take Santa?

  ## Examples
      iex> lift_diff("(")
      1

      iex> lift_diff(")")
      -1

      iex> lift_diff("(())")
      0
      iex> lift_diff("()()")
      0

      iex> lift_diff("(((")
      3
      iex> lift_diff("(()(()(")
      3
      iex> lift_diff("))(((((")
      3

      iex> lift_diff("())")
      -1
      iex> lift_diff("))(")
      -1

      iex> lift_diff(")))")
      -3
      iex> lift_diff(")())())")
      -3
  """
  def lift_diff(instructions) do
    instructions
    |> String.codepoints
    |> Enum.reduce(0, fn(i, acc) ->
      acc + if i == "(", do: 1, else: -1
    end)
  end

  @doc """
  Now, given the same instructions, find the *position* of the first character
  that causes him to enter the basement (floor `-1`). The first character in the
  instructions has position `1`, the second character has position `2`, and so
  on.

  ## Examples
      iex> lift_pos(")", -1)
      1

      iex> lift_pos("()())", -1)
      5
  """
  def lift_pos(instructions, pos) do
    instructions
    |> String.codepoints
    |> do_lift_pos(0, 0, pos)
  end

  defp do_lift_pos(_, i, n, pos) when n == pos, do: i
  defp do_lift_pos([], _, _, _), do: -1
  defp do_lift_pos([h|t], i, n, pos) do
    do_lift_pos(t, i + 1, n + lift_diff(h), pos)
  end
end
