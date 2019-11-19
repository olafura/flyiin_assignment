defmodule FlyiinAssignmentWeb.FindCheapestOffer do
  @moduledoc """
  Rest endpoint to find the cheapest offers based on origin, destination and departure date,
  from all supported airlies.
  """

  use FlyiinAssignmentWeb, :controller
  require Logger

  alias FlyiinAssignment.Airlines

  def show(conn, %{
        "origin" => origin,
        "destination" => destination,
        "departureDate" => departure_date
      }) do
    case Airlines.find_cheapest_offer(origin, departure_date, destination) do
      {:ok, {airline, %{total: amount}}} ->
        json(conn, %{"data" => %{"cheapestOffer" => %{"amount" => amount, "airline" => airline}}})

      {:error, errors} ->
        json(conn, %{"errors" => errors |> Keyword.values() |> ensure_binaries()})

      other ->
        Logger.error("FindCheapestOfferController unknown error #{inspect(other)}")
        json(conn, %{"errors" => ["Unknown error"]})
    end
  end

  defp ensure_binaries(list) do
    list
    |> Enum.map(&ensure_binary/1)
  end

  defp ensure_binary(list) when is_list(list) do
    to_string(list)
  end

  defp ensure_binary(binary) when is_binary(binary) do
    binary
  end

  defp ensure_binary(other) do
    inspect(other)
  end
end
