alias HTTPoison.Response, as: Response

defmodule Spotify do
  use Agent
  @client_id System.get_env("SPOTIFY_CLIENT_ID")
  @client_secret System.get_env("SPOTIFY_CLIENT_SECRET")
  @header_token Base.encode64("#{@client_id}:#{@client_secret}")

  @valid_genre_substrings ["emo", "screamo", "punk"]

  def start_link() do
    Agent.start_link(&fetch_auth_token/0, name: __MODULE__)
  end

  def auth_token do
    Agent.get(__MODULE__, & &1)
  end

  defp fetch_auth_token do
    %Response{body: body} =
      HTTPoison.post!(
        "https://accounts.spotify.com/api/token",
        URI.encode_query(%{grant_type: "client_credentials"}),
        Authorization: "Basic #{@header_token}",
        "Content-Type": "application/x-www-form-urlencoded"
      )

    %{"access_token" => access_token} = Jason.decode!(body)
    access_token
  end

  def get_artist_tournament_info(artist) do
    # See: https://developer.spotify.com/documentation/web-api/reference/#category-search
    cleaned = String.replace(artist, " ", "%20")

    response =
      HTTPoison.get!(
        "https://api.spotify.com/v1/search?q=#{cleaned}&type=artist",
        Authorization: "Bearer #{auth_token()}"
      ).body
      |> Jason.decode!()

    artists = response["artists"]["items"]
    emo_artist = artists |> Enum.find(:not_found, &has_valid_subgenre?/1)

    if emo_artist == :not_found do
      IO.inspect(artist)
      genres = artists |> Enum.map(fn json -> json["genres"] end)
      IO.inspect(genres)
      raise "Couldn't find emo or punk artist"
    end

    %Band{
      name: emo_artist["name"],
      popularity: emo_artist["popularity"],
      followers: emo_artist["followers"]["total"]
    }
  end

  # This is gross, but sometimes more popular bands with a similar name show up first
  # due to heuristics in Spotify's search API. We do our best here to grab the first
  # artist that matches one of the genres above.
  defp has_valid_subgenre?(artist) do
    artist["genres"] |> Enum.any?(&is_valid_genre?/1)
  end

  defp is_valid_genre?(genre) do
    @valid_genre_substrings |> Enum.any?(&String.contains?(genre, &1))
  end
end
