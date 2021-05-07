defmodule Band do
  @enforce_keys [:name, :popularity, :followers]
  defstruct [:name, :popularity, :followers]
end

# case class Battle(left: Tournament, right: Tournament) extends Tournament
