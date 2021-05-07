defmodule Band do
  @keys [:name, :popularity, :followers]
  @enforce_keys @keys
  defstruct @keys
end

# case class Battle(left: Tournament, right: Tournament) extends Tournament
