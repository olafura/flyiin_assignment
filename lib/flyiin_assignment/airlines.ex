defmodule FlyiinAssignment.Airlines do
  alias FlyiinAssignment.Airline.{AirFranceKLM, BritishAirways}

  @airlines [
    {"AF", AirFranceKLM},
    {"BA", BritishAirways}
  ]

  def get_prices(origin, departure_date, destination) do
    @airlines
    |> Enum.map(fn {airline_code, module} ->
      Task.Supervisor.async(FlyiinAssignment.TaskSupervisor, fn ->
        %{travel_agency: travel_agency} =
          Application.get_env(:flyiin_assignment, module) |> Map.new()

        {airline_code,
         module.get_price(travel_agency, airline_code, origin, departure_date, destination)}
      end)
    end)
    |> Task.yield_many()
    |> Enum.map(fn
      {_task, {:ok, {airline_code, {:ok, result}}}} -> {airline_code, result}
      {_task, {:ok, {_airline_code, error}}} -> error
      {_task, error} -> error
    end)
  end

  def get_cheapest_offer(origin, departure_date, destination) do
    prices = get_prices(origin, departure_date, destination)

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
