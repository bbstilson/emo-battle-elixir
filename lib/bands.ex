defmodule Bands do
  @bands_data_file File.cwd!() <> "/bands-data.jsonl"

  # Order in this list matters. Bands are recursively matched pair-wise.
  # For example, [a, b, c, d] == ((a vs b) vs (c vs d))
  @band_names [
    "blink-182",
    "home grown",
    "a day to remember",
    "coheed and cambria",
    "panic! at the disco",
    "from first to last",
    "the used",
    "hawthorne heights",
    "simple plan",
    "bayside",
    "yellowcard",
    "the rocket Summer",
    "boys like girls",
    "senses fail",
    "brand new",
    "cute is what we aim for",
    "my chemical romance",
    "the red jumpsuit apparatus",
    "afi",
    "the academy is",
    "good charlotte",
    "plain white ts",
    "alkaline trio",
    "mae",
    "the starting line",
    "hidden in plain view",
    "sum-41",
    "the maine",
    "cartel",
    "acceptance",
    "jimmy eat world",
    "finch",
    "green Day",
    "spitalfied",
    "relient k",
    "saves the Day",
    "paramore",
    "hellogoodbye",
    "underoath",
    "saosin",
    "midtown",
    "story of the year",
    "new found glory",
    "the spill canvas",
    "something corporate",
    "thursday",
    "taking back sunday",
    "armor for sleep",
    "fall out boy",
    "forever the sickest kids",
    "motion city soundtrack",
    "say anything",
    "the all-american rejects",
    "silverstein",
    "the get up kids",
    "four year strong",
    "mayday parade",
    "the early november",
    "all time low",
    "matchbook romance",
    "the ataris",
    "the movielife",
    "dashboard confessionals",
    "allister"
  ]

  def fetch_artist_info(artist) do
    # An attempt at being respecful of api rate limits uwu.
    :timer.sleep(100)
    Spotify.get_artist_tournament_info(artist)
  end

  def _append_artist_data(artist) do
    File.write!(@bands_data_file, Jason.encode!(artist) <> "\n", [:append])
  end

  def fetch_band_data do
    bands = @band_names |> Enum.map(&fetch_artist_info/1)
    # Cache bands for repeat runs.
    bands |> Enum.each(&_append_artist_data/1)
    # Return bands
    bands
  end

  def parse_file_data(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&Jason.decode!/1)
    |> Enum.map(&Band.from_json/1)
  end

  def data do
    case File.read(@bands_data_file) do
      {:ok, data} -> parse_file_data(data)
      _ -> fetch_band_data()
    end
  end
end
