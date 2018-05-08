defmodule CpDownload do
  #use HTTPoison.Base
  @moduledoc """
  Documentation for CpDownload.
  """

  @doc """
  Hello world.

  ## Examples

      iex> CpDownload.hello
      :world

  """
  def hello do
    filename = "lib/events.txt"

    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.with_index
    |> Stream.map(fn ({line, _}) ->


      case HTTPoison.get("https://shippit-web-production.s3.amazonaws.com/#{line}") do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          File.write("lib/output.txt", body, [:append])
        {:ok, %HTTPoison.Response{status_code: 404}} ->
          IO.puts "Not found :("
        {:error, %HTTPoison.Error{reason: reason}} ->
          IO.inspect reason
      end
    end)
    |> Stream.run
  end
end
