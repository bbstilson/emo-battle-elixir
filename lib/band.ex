defmodule Band do
  @derive Jason.Encoder
  @keys [:name, :popularity, :followers]
  @enforce_keys @keys
  defstruct @keys

  def from_json(json) do
    %Band{
      name: json["name"],
      popularity: json["popularity"],
      followers: json["followers"]
    }
  end

  def score(band) do
    band.popularity * band.followers
  end
end
