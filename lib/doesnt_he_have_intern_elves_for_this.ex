defmodule DoesntHeHaveInternElvesForThis do

  def nice_count(input, nice_fn) do
    input
    |> String.split("\n", trim: true)
    |> Enum.filter(nice_fn)
    |> Enum.count
  end

  @doc """
  Santa needs help figuring out which strings in his text file are naughty or
  nice.

  A *nice string* is one with all of the following properties:

  It contains at least three vowels (`aeiou` only), like `aei`, `xazegov`, or
  `aeiouaeiouaeiou`.
  It contains at least one letter that appears twice in a row, like `xx`,
  `abcdde` (`dd`), or `aabbccdd` (`aa`, `bb`, `cc`, or `dd`).
  It does not contain the strings `ab`, `cd`, `pq`, or `xy`, even if they are
  part of one of the other requirements.

  For example:

  `ugknbfddgicrmopn` is nice because it has at least three vowels
  (`u...i...o...`), a double letter (`...dd...`), and none of the disallowed
  substrings.
  `aaa` is nice because it has at least three vowels and a double letter, even
  though the letters used by different rules overlap.
  `jchzalrnumimnmhp` is naughty because it has no double letter.
  `haegwjzuvuyypxyu` is naughty because it contains the string `xy`.
  `dvszwmarrgswjxmb` is naughty because it contains only one vowel.

  How many strings are nice?

  ## Example
      iex> "ugknbfddgicrmopn" |> nice?
      true

      iex> "aaa" |> nice?
      true

      iex> "jchzalrnumimnmhp" |> nice?
      false

      iex> "haegwjzuvuyypxyu" |> nice?
      false

      iex> "dvszwmarrgswjxmb" |> nice?
      false

  """
  def nice?(input) do
    three_vowels?(input) && double_letters?(input) && !naughty_string?(input)
  end

  @doc """
  It contains at least three vowels (`aeiou` only), like `aei`, `xazegov`, or
  `aeiouaeiouaeiou`.

  ##Example
      iex> "aei" |> three_vowels?
      true

      iex> "xazegov" |> three_vowels?
      true

      iex> "aeiouaeiouaeiou" |> three_vowels?
      true

      iex> "aex" |> three_vowels?
      false
  """
  def three_vowels?(input) do
    Regex.scan(~r/([aeiou])/, input, capture: :all_but_first)
    |> List.flatten
    |> Enum.count >= 3
  end

  @doc """
  It contains at least one letter that appears twice in a row, like `xx`,
  `abcdde` (`dd`), or `aabbccdd` (`aa`, `bb`, `cc`, or `dd`).

  ## Example
      iex> "xx" |> double_letters?
      true

      iex> "abcdde" |> double_letters?
      true

      iex> "aabbccdd" |> double_letters?
      true

      iex> "ababa" |> double_letters?
      false
  """
  def double_letters?(input) do
    String.codepoints(input)
    |> do_double_letters?(nil)
  end

  def do_double_letters?([], _), do: false
  def do_double_letters?([h|t], prev) do
    case h == prev do
      false -> do_double_letters?(t, h)
      _ -> true
    end
  end

  @doc """
  It does not contain the strings `ab`, `cd`, `pq`, or `xy`, even if they are
  part of one of the other requirements.

  ## Example
      assert "ab" |> naughty_string? == true

      assert "cd" |> naughty_string? == true

      assert "pq" |> naughty_string? == true

      assert "xy" |> naughty_string? == true

      assert "bc" |> naughty_string? == true
  """
  def naughty_string?(input) do
    String.contains?(input, ["ab", "cd", "pq", "xy"])
  end

  @doc """
  Realizing the error of his ways, Santa has switched to a better model of
  determining whether a string is naughty or nice. None of the old rules apply,
  as they are all clearly ridiculous.

  Now, a nice string is one with all of the following properties:

  It contains a pair of any two letters that appears at least twice in the
  string without overlapping, like `xyxy` (`xy`) or `aabcdefgaa` (`aa`), but not
  like `aaa` (`aa`, but it overlaps).
  It contains at least one letter which repeats with exactly one letter between
  them, like `xyx`, `abcdefeghi` (`efe`), or even `aaa`.

  For example:

  `qjhvhtzxzqqjkmpb` is nice because is has a pair that appears twice (`qj`) and
  a letter that repeats with exactly one letter between them (`zxz`).
  `xxyxx` is nice because it has a pair that appears twice and a letter that
  repeats with one between, even though the letters used by each rule overlap.
  `uurcxstgmygtbstg` is naughty because it has a pair (`tg`) but no repeat with
  a single letter between them.
  `ieodomkazucvgmuy` is naughty because it has a repeating letter with one
  between (`odo`), but no pair that appears twice.

  How many strings are nice under these new rules?

  ## Example
      iex> "qjhvhtzxzqqjkmpb" |> new_nice?
      true

      iex> "xxyxx" |> new_nice?
      true

      iex> "uurcxstgmygtbstg" |> new_nice?
      false

      iex> "ieodomkazucvgmuy" |> new_nice?
      false
  """
  def new_nice?(input) do
    nice_letter_pairs?(input) && nice_repeat?(input)
  end

  @doc """
  It contains a pair of any two letters that appears at least twice in the
  string without overlapping, like `xyxy` (`xy`) or `aabcdefgaa` (`aa`), but not
  like `aaa` (`aa`, but it overlaps).

  ## Example
      iex> "xyxy" |> nice_letter_pairs?
      true

      iex> "aabcdefgaa" |> nice_letter_pairs?
      true

      iex> "aaa" |> nice_letter_pairs?
      false
  """
  def nice_letter_pairs?(input) do
    do_nlp(input, 0, String.length(input), [])
    |> Enum.any?
  end

  # Divide input into prefix, current examined pair, and postfix and see if pair
  # exists in either pre- or postfix.
  #
  # looping though the input `xyxy`
  # 0: prefix: "",   pair: "xy", postfix: "xy" # found!
  # 1: prefix: "x",  pair: "yx", postfix: "y"
  # 2: prefix: "xy", pair: "xy", postfix: ""   # found!
  def do_nlp(_, i, length, list) when i == length - 1, do: list
  def do_nlp(input, i, length, list) do
    prefix = String.slice(input, 0, i)
    pair = String.slice(input, i, 2)
    postfix = String.slice(input, i + 2, String.length(input))
    do_nlp(input, i + 1, length, list ++ [String.contains?(prefix, pair) || String.contains?(postfix, pair)])
  end

  @doc """
  It contains at least one letter which repeats with exactly one letter between
  them, like `xyx`, `abcdefeghi` (`efe`), or even `aaa`.

  ## Example
      iex> "xyx" |> nice_repeat?
      true

      iex> "abcdefeghi" |> nice_repeat?
      true

      iex> "aaa" |> nice_repeat?
      true

      iex> "abba" |> nice_repeat?
      false
  """
  def nice_repeat?(input) do
    do_nice_repeat(String.codepoints(input), "", "")
  end

  def do_nice_repeat([], _, _), do: false
  def do_nice_repeat([h | _], _, penultimate) when h == penultimate, do: true
  def do_nice_repeat([h | t], prev, _) do
    do_nice_repeat(t, h, prev)
  end
end
