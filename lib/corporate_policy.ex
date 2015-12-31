defmodule CorporatePolicy do
  @moduledoc """
  --- Day 11: Corporate Policy ---

  Santa's previous password expired, and he needs help choosing a new one.

  To help him remember his new password after the old one expires, Santa has
  devised a method of coming up with a password based on the previous one.
  Corporate policy dictates that passwords must be exactly eight lowercase
  letters (for security reasons), so he finds his new password by incrementing
  his old password string repeatedly until it is valid.

  Incrementing is just like counting with numbers: xx, xy, xz, ya, yb, and so
  on. Increase the rightmost letter one step; if it was z, it wraps around to a,
  and repeat with the next letter to the left until one doesn't wrap around.

  Unfortunately for Santa, a new Security-Elf recently started, and he has
  imposed some additional password requirements:

  Passwords must include one increasing straight of at least three letters, like
  abc, bcd, cde, and so on, up to xyz. They cannot skip letters; abd doesn't
  count.
  Passwords may not contain the letters i, o, or l, as these letters can be
  mistaken for other characters and are therefore confusing.
  Passwords must contain at least two different, non-overlapping pairs of
  letters, like aa, bb, or zz.

  For example:

  hijklmmn meets the first requirement (because it contains the straight hij)
  but fails the second requirement requirement (because it contains i and l).
  abbceffg meets the third requirement (because it repeats bb and ff) but fails
  the first requirement.
  abbcegjk fails the third requirement, because it only has one double letter
  (bb).
  The next password after abcdefgh is abcdffaa.
  The next password after ghijklmn is ghjaabcc, because you eventually skip all
  the passwords that start with ghi..., since i is not allowed.

  Given Santa's current password (your puzzle input), what should his next
  password be?

  Your puzzle input is `vzbxkghb`.

  --- Part Two ---

Santa's password expired again. What's the next one?

Your puzzle input is still `vzbxkghb`.

"""

  @doc """
  ## Example
      iex> inc "xy"
      "xz"

      iex> inc "xz"
      "ya"

      iex> inc "ya"
      "yb"
  """
  def inc(input) do
    do_inc(input |> to_char_list |> Enum.reverse) |> Enum.reverse |> to_string
  end

  defp do_inc([h | t]) do
    letter = rem(h - ?a + 1, ?z - ?a + 1) + ?a
    case letter do
      ?a -> [letter | do_inc(t)]
      ?i -> do_inc([letter | t])
      ?l -> do_inc([letter | t])
      ?o -> do_inc([letter | t])
      _ -> [letter | t]
    end
  end

  @doc """
  Passwords must include one increasing straight of at least three letters, like
  abc, bcd, cde, and so on, up to xyz. They cannot skip letters; abd doesn't
  count.

  ## Example
      iex> increasing_straight? "abc"
      true

      iex> increasing_straight? "abd"
      false

      iex> increasing_straight? "ghjaabcc"
      true
  """
  def increasing_straight?(input) do
    input |> to_char_list |> Enum.chunk(3, 1)
    |> Enum.any?(fn([x, y, z]) ->
      y == x + 1 && z == y + 1
    end)
  end

  @doc """
  Passwords may not contain the letters i, o, or l, as these letters can be
  mistaken for other characters and are therefore confusing.

  ## Example
      iex> fine_letters? "def"
      true

      iex> fine_letters? "ghi"
      false

      iex> fine_letters? "jkl"
      false

      iex> fine_letters? "mno"
      false
  """
  def fine_letters?(input) do
    !String.contains?(input, ["i", "l", "o"])
  end

  @doc """
  Passwords must contain at least two different, non-overlapping pairs of
  letters, like aa, bb, or zz.

  ## Example
      iex> two_letter_pairs? "aaaa"
      true

      iex> two_letter_pairs? "aaa"
      false

      iex> two_letter_pairs? "zaazaa"
      true
  """
  def two_letter_pairs?(input) do
    input
    |> to_char_list
    |> Enum.chunk(2, 1)
    |> count_pairs(0)
    > 1
  end

  def count_pairs([], count), do: count
  def count_pairs([[x, y] | t], count) when x == y and t == [], do: count+1
  def count_pairs([[x, y], _ | t], count) when x == y do
    count_pairs(t, count + 1)
  end
  def count_pairs([_ | t], count) do
    count_pairs(t, count)
  end

  @doc """
  hijklmmn meets the first requirement (because it contains the straight hij)
  but fails the second requirement requirement (because it contains i and l).
  abbceffg meets the third requirement (because it repeats bb and ff) but fails
  the first requirement.
  abbcegjk fails the third requirement, because it only has one double letter
  (bb).

  ## Example
      iex> secure? "hijklmmn"
      false

      iex> secure? "abbceffg"
      false

      iex> secure? "abbcdegj"
      false

      iex> secure? "abcdffaa"
      true
  """
  def secure?(input) do
    increasing_straight?(input) && fine_letters?(input) && two_letter_pairs?(input)
  end

  @doc """
  The next password after abcdefgh is abcdffaa.
  The next password after ghijklmn is ghjaabcc, because you eventually skip all
  the passwords that start with ghi..., since i is not allowed.

  ## Example
      iex> next_password("abcdefgh")
      "abcdffaa"
  """
  def next_password(input) do
    password = inc(input)
    cond do
      secure?(password) -> password
      true -> next_password(password)
    end
  end
end
