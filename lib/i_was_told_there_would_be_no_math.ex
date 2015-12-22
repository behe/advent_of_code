defmodule IWasToldThereWouldBeNoMath do
  @doc """
  The elves are running low on wrapping paper, and so they need to submit an
  order for more. They have a list of the dimensions (length `l`, width `w`, and
  height `h`) of each present, and only want to order exactly as much as they
  need.

  Fortunately, every present is a box (a perfect right rectangular prism), which
  makes calculating the required wrapping paper for each gift a little easier:
  find the surface area of the box, which is `2*l*w + 2*w*h + 2*h*l`. The elves
  also need a little extra paper for each present: the area of the smallest
  side.

  ## Examples
      iex> paper("2x3x4")
      58

      iex> paper("1x1x10")
      43

      iex> paper("2x3x4\\n1x1x10")
      101

  All numbers in the elves' list are in feet. How many total `square feet of
  wrapping paper` should they order?
  """
  def paper(dimensions) do
    dimensions
    |> String.split("\n", trim: true)
    |> Enum.map(&do_paper/1)
    |> Enum.reduce(0, fn(dim, acc) ->
      dim + acc
    end)
  end

  defp do_paper(dimension) do
    [x,y,z] = to_dimensions(dimension)
    dim = [x*y, x*z, y*z]
    (dim ++ dim ++ [Enum.min(dim)])
    |> Enum.reduce(0, fn(x,a) ->
      x+a
    end)
  end

  defp to_dimensions(dimensions) when is_bitstring(dimensions) do
    dimensions
    |> String.split("x")
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  The elves are also running low on ribbon. Ribbon is all the same width, so
  they only have to worry about the length they need to order, which they would
  again like to be exact.

  The ribbon required to wrap a present is the shortest distance around its
  sides, or the smallest perimeter of any one face. Each present also requires
  a bow made out of ribbon as well; the feet of ribbon required for the perfect
  bow is equal to the cubic feet of volume of the present. Don't ask how they
  tie the bow, though; they'll never tell.

  ## Examples
      iex> ribbon("2x3x4")
      34

      iex> ribbon("1x1x10")
      14

      iex> ribbon("2x3x4\\n1x1x10")
      48
  """
  def ribbon(dimensions) do
    dimensions
    |> String.split("\n", trim: true)
    |> Enum.map(&do_ribbon/1)
    |> Enum.reduce(0, fn(dim, acc) ->
      dim + acc
    end)
  end

  def do_ribbon(dimension) do
    dim = to_dimensions(dimension)
    z = Enum.max(dim)
    [x, y] = dim -- [z]
    x+x+y+y+(x*y*z)
  end
end
