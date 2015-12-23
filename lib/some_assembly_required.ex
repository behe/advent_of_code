defmodule SomeAssemblyRequired do
  use Bitwise

  @doc """
  ## Example
      iex> "123 -> x
      ...>456 -> y
      ...>x AND y -> d
      ...>x OR y -> e
      ...>x LSHIFT 2 -> f
      ...>y RSHIFT 2 -> g
      ...>NOT x -> h
      ...>NOT y -> i" |> parse
      %{
        "x" => %{args: 123, operation: :assign},
        "y" => %{args: 456, operation: :assign},
        "d" => %{args: ["x", "y"], operation: :and},
        "e" => %{args: ["x", "y"], operation: :or},
        "f" => %{args: ["x", 2], operation: :lshift},
        "g" => %{args: ["y", 2], operation: :rshift},
        "h" => %{args: "x", operation: :not},
        "i" => %{args: "y", operation: :not},
      }
  """
  def parse(input) do
    String.split(input, "\n", trim: true)
    |> Enum.reduce(%{}, fn(instruction, acc) ->
      [val, var] = String.split(instruction, " -> ")
      op = val |> String.split |> parse_operation
      Map.put_new(acc, var, op)
    end)
  end

  def parse_operation(["NOT", x]) do
    %{args: x, operation: :not}
  end
  def parse_operation([x, "RSHIFT", y]) do
    %{args: [x, to_i(y)], operation: :rshift}
  end
  def parse_operation([x, "LSHIFT", y]) do
    %{args: [x, to_i(y)], operation: :lshift}
  end
  def parse_operation([x, "OR", y]) do
    %{args: [x, y], operation: :or}
  end
  def parse_operation([x, "AND", y]) do
    %{args: [to_i(x), y], operation: :and}
  end
  def parse_operation([val]) do
    %{args: to_i(val), operation: :assign}
  end

  def to_i(val) do
    case Integer.parse(val) do
      :error -> val
      {int, _} -> int
    end
  end

  @doc """
  This year, Santa brought little Bobby Tables a set of wires and bitwise logic
  gates! Unfortunately, little Bobby is a little under the recommended age
  range, and he needs help assembling the circuit.

  Each wire has an identifier (some lowercase letters) and can carry a 16-bit
  signal (a number from 0 to 65535). A signal is provided to each wire by a
  gate, another wire, or some specific value. Each wire can only get a signal
  from one source, but can provide its signal to multiple destinations. A gate
  provides no signal until all of its inputs have a signal.

  The included instructions booklet describes how to connect the parts together:
  x AND y -> z means to connect wires x and y to an AND gate, and then connect
  its output to wire z.

  For example:

  123 -> x means that the signal 123 is provided to wire x.
  x AND y -> z means that the bitwise AND of wire x and wire y is provided to
  wire z.
  p LSHIFT 2 -> q means that the value from wire p is left-shifted by 2 and then
  provided to wire q.
  NOT e -> f means that the bitwise complement of the value from wire e is
  provided to wire f.
  Other possible gates include OR (bitwise OR) and RSHIFT (right-shift). If, for
  some reason, you'd like to emulate the circuit instead, almost all programming
  languages (for example, C, JavaScript, or Python) provide operators for these
  gates.

  For example, here is a simple circuit:

  123 -> x
  456 -> y
  x AND y -> d
  x OR y -> e
  x LSHIFT 2 -> f
  y RSHIFT 2 -> g
  NOT x -> h
  NOT y -> i

  After it is run, these are the signals on the wires:

  d: 72
  e: 507
  f: 492
  g: 114
  h: 65412
  i: 65079
  x: 123
  y: 456

  In little Bobby's kit's instructions booklet (provided as your puzzle input),
  what signal is ultimately provided to wire a?

  ## Example
      iex> "123 -> x
      ...>456 -> y
      ...>1 AND x -> c
      ...>x AND y -> d
      ...>x OR y -> e
      ...>x LSHIFT 2 -> f
      ...>y RSHIFT 2 -> g
      ...>NOT x -> h
      ...>NOT y -> i" |> parse |> find_value(["x", "y", "c", "d", "e", "f", "g", "h", "i"])
      [123, 456, 1, 72, 507, 492, 114, 65412, 65079]
  """
  def find_value(ops, vals) when is_list(vals) do
    Enum.map_reduce(vals, ops, fn(val, ops) ->
      find_value(ops, val)
    end)
    |> elem(0)
  end
  def find_value(ops, val) do
    do_find_value(ops, ops[val], val)
  end
  def do_find_value(ops, nil, val), do: {val, ops}
  def do_find_value(ops, %{args: [x, y], operation: op}, n) do
    {x, ops} = do_find_value(ops, ops[x], x)
    {y, ops} = do_find_value(ops, ops[y], y)
    result = operation(op).(x, y)
    ops = put_in(ops, [n], %{args: result, operation: :assign})
    {result, ops}
  end
  def do_find_value(ops, %{args: arg, operation: op}, n) do
    {arg, ops} = do_find_value(ops, ops[arg], arg)
    result = operation(op).(arg)
    ops = put_in(ops, [n], %{args: result, operation: :assign})
    {result, ops}
  end

  def operation(:assign), do: &(&1)
  def operation(:not), do: &(65536 + bnot(&1))
  def operation(:and), do: &band(&1, &2)
  def operation(:or), do: &bor(&1, &2)
  def operation(:lshift), do: &bsl(&1, &2)
  def operation(:rshift), do: &bsr(&1, &2)
end
