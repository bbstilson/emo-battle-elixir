defmodule EmoBattle do
  def build_tournament([]) do
    raise "This should not be HAPPENING"
  end

  def build_tournament([tournament]) do
    tournament
  end

  def build_tournament(battles) do
    tiered =
      battles
      |> Enum.chunk_every(2, 2)
      |> Enum.map(&Battle.from_chunk/1)

    build_tournament(tiered)
  end

  def band_battle(b1, b2, tier) do
    padding = String.duplicate("- - ", tier) <> " "

    winner =
      if Band.score(b1) > Band.score(b2) do
        b1
      else
        b2
      end

    IO.puts(padding <> "#{b1.name} vs #{b2.name}. Winner is #{winner.name}!")
    winner
  end

  # Base case.
  def run_tournament(%Battle{left: %Band{}, right: %Band{}} = battle, tier) do
    band_battle(battle.left, battle.right, tier)
  end

  # Recursive case.
  def run_tournament(%Battle{left: left, right: right}, tier) do
    next_tier = tier + 1
    winner_left = run_tournament(left, next_tier)
    winner_right = run_tournament(right, next_tier)
    band_battle(winner_left, winner_right, tier)
  end

  def battle() do
    Spotify.start_link()

    competitors = Bands.data()
    tournament = build_tournament(competitors)
    winner = run_tournament(tournament, 0)
    IO.puts("")
    IO.puts("Champion: #{winner.name}!")
  end
end
