defmodule FlyiinAssignmentWeb.FindCheapestOffer do
  use FlyiinAssignmentWeb, :controller
  require Logger

  alias FlyiinAssignment.Airlines

  def show(conn, %{
        "origin" => origin,
        "destination" => destination,
        "departureDate" => departure_date
      }) do
    with {:ok, {airline, %{total: amount}}} <-
           Airlines.get_cheapest_offer(origin, departure_date, destination) do
      json(conn, %{"data" => %{"cheapestOffer" => %{"amount" => amount, "airline" => airline}}})
    else
      {:error, errors} ->
        IO.inspect(errors)
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
