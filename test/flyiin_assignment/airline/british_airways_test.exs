defmodule FlyiinAssignment.Airline.BritishAirwaysTest do
  use ExUnit.Case, async: true

  alias FlyiinAssignment.Airline.BritishAirways

  @tag :external
  test "Test correct date" do
    %{travel_agency: travel_agency} =
      Application.get_env(:flyiin_assignment, BritishAirways) |> Map.new()

    airline = "BA"
    origin = "MUC"
    destination = "LHR"
    today = Date.utc_today()
    departure_date = today |> Date.add(10) |> Date.to_string()

    assert {:ok, _data} =
             BritishAirways.fetch_price(
               travel_agency,
               airline,
               origin,
               departure_date,
               destination
             )
  end

  @tag :external
  test "Test incorrect date" do
    %{travel_agency: travel_agency} =
      Application.get_env(:flyiin_assignment, BritishAirways) |> Map.new()

    airline = "BA"
    origin = "MUC"
    destination = "LHR"
    departure_date = "1979-01-01"

    assert {:error, _error_message} =
             BritishAirways.fetch_price(
               travel_agency,
               airline,
               origin,
               departure_date,
               destination
             )
  end
end
