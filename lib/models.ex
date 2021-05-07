defmodule Band do
  @derive Jason.Encoder
  @keys [:name, :popularity, :followers]
  @enforce_keys @keys
  defstruct @keys
end

defmodule Battle do
  @keys [:left, :right]
  @enforce_keys @keys
  defstruct @keys
end
