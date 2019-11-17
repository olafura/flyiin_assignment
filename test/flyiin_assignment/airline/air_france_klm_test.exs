defmodule FlyiinAssignment.Airline.AirFranceKLMTest do
  use ExUnit.Case, async: true

  alias FlyiinAssignment.Airline.AirFranceKLM

  @tag :external
  test "Test correct date" do
    travel_agency = %{name: "test", city: "PARMM211L", iata_number: "12345675", id: "id"}
    airline = "AF"
    origin = "MUC"
    destination = "LHR"
    today = Date.utc_today()
    departure_date = today |> Date.add(10) |> Date.to_string()

    assert {:ok, _data} =
             AirFranceKLM.get_price(travel_agency, airline, origin, departure_date, destination)
  end

  @tag :external
  test "Test incorrect date" do
    travel_agency = %{name: "test", city: "PARMM211L", iata_number: "12345675", id: "id"}
    airline = "AF"
    origin = "MUC"
    destination = "LHR"
    departure_date = "1979-01-01"

    assert {:error, _error_message} =
             AirFranceKLM.get_price(travel_agency, airline, origin, departure_date, destination)
  end
end
