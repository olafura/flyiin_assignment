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

        module.get_price(travel_agency, airline_code, origin, departure_date, destination)
      end)
    end)
    |> Task.yield_many()
  end
end
