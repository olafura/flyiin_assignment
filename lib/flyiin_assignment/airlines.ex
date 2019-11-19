defmodule FlyiinAssignment.Airlines do
  @moduledoc """
  Provides ways of fetching information from the supported airlines which
  are Air France-KLM and British Airways. Through the open schema from
  IATA regarding airshopping.
  """

  alias FlyiinAssignment.Airline.{AirFranceKLM, BritishAirways}

  @airlines [
    {"AF", AirFranceKLM},
    {"BA", BritishAirways}
  ]

  @doc """
  Fetches the price information from all the supported airlines
  """
  def fetch_prices(origin, departure_date, destination) do
    @airlines
    |> Enum.map(fn {airline_code, module} ->
      Task.Supervisor.async(FlyiinAssignment.TaskSupervisor, fn ->
        %{travel_agency: travel_agency} =
          Application.get_env(:flyiin_assignment, module) |> Map.new()

        {airline_code,
         module.fetch_price(travel_agency, airline_code, origin, departure_date, destination)}
      end)
    end)
    |> Task.yield_many()
    |> Enum.map(fn
      {_task, {:ok, {airline_code, {:ok, result}}}} -> {airline_code, result}
      {_task, {:ok, {_airline_code, error}}} -> error
      {_task, error} -> error
    end)
  end

  @doc """
  Finds the cheapest offer given the available information the supported airlines.
  If there are errors fetching information from some airline and there are other
  offers it will ignore that error. If we can't find any offers it will return
  any error we got.
  """
  def find_cheapest_offer(origin, departure_date, destination) do
    prices = fetch_prices(origin, departure_date, destination)

    result =
      prices
      |> Enum.reject(&match?({:error, _}, &1))
      |> Enum.sort_by(fn {_, %{total: total}} -> total end)
      |> List.first()

    if is_nil(result) do
      {:error, prices}
    else
      {:ok, result}
    end
  end
end
