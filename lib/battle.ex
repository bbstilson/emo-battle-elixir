defmodule Battle do
  @keys [:left, :right]
  @enforce_keys @keys
  defstruct @keys

  def from_chunk([left, right]) do
    %Battle{left: left, right: right}
  end
end
