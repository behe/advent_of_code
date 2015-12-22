defmodule PerfectlySphericalHousesInAVacuum do
  @doc """
  Santa is delivering presents to an infinite two-dimensional grid of houses.

  He begins by delivering a present to the house at his starting location, and
  then an elf at the North Pole calls him via radio and tells him where to move
  next. Moves are always exactly one house to the north (`^`), south (`v`), east
  (`>`), or west (`<`). After each move, he delivers another present to the
  house at his new location.

  However, the elf back at the north pole has had a little too much eggnog, and
  so his directions are a little off, and Santa ends up visiting some houses
  more than once. How many houses receive at least one present?

  For example:

  `>` delivers presents to `2` houses: one at the starting location, and one to
  the east.
  `^>v<` delivers presents to `4` houses in a square, including twice to the
  house at his starting/ending location.
  `^v^v^v^v^v` delivers a bunch of presents to some very lucky children at only
  `2` houses.

  ## Example
      iex> ">" |> unique_houses
      2

      iex> "^>v<" |> unique_houses
      4

      iex> "^v^v^v^v^v" |> unique_houses
      2
  """
  def unique_houses(instructions) do
    String.codepoints(instructions)
    |> to_coords
    |> Enum.uniq
    |> Enum.count
  end

  def to_coords(instructions) do
    instructions
    |> Enum.map_reduce({0, 0}, fn(inst, {x, y}) ->
      coord = case inst do
        "v" -> {x, y - 1}
        "^" -> {x, y + 1}
        "<" -> {x - 1, y}
        ">" -> {x + 1, y}
      end
      {coord, coord}
    end)
    |> elem(0)
    |> List.insert_at(0, {0, 0})
  end

  @doc """
  The next year, to speed up the process, Santa creates a robot version of
  himself, Robo-Santa, to deliver presents with him.

  Santa and Robo-Santa start at the same location (delivering two presents to
  the same starting house), then take turns moving based on instructions from
  the elf, who is eggnoggedly reading from the same script as the previous year.

  This year, how many houses receive at least one present?

  For example:

  `^v` delivers presents to `3` houses, because Santa goes north, and then
  Robo-Santa goes south.
  `^>v<` now delivers presents to `3` houses, and Santa and Robo-Santa end up
  back where they started.
  `^v^v^v^v^v` now delivers presents to `11` houses, with Santa going one
  direction and Robo-Santa going the other.

  ## Example
      iex> "^v" |> robo_unique_houses
      3

      iex> "^>v<" |> robo_unique_houses
      3

      iex> "^v^v^v^v^v" |> robo_unique_houses
      11
  """
  def robo_unique_houses(instructions) do
    {santa, robo} = String.codepoints(instructions)
    |> Enum.chunk(2)
    |> Enum.map(fn([x,y]) -> {x, y} end)
    |> Enum.unzip
    to_coords(santa) ++ to_coords(robo)
    |> Enum.uniq
    |> Enum.count
  end
end
