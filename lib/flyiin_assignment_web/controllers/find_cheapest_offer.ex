defmodule FlyiinAssignmentWeb.FindCheapestOffer do
  use FlyiinAssignmentWeb, :controller

  alias FlyiinAssignment.Airlines

  def show(conn, %{
        "origin" => origin,
        "destination" => destination,
        "departureDate" => departure_date
      }) do
    {airline, %{total: amount}} = Airlines.get_cheapest_offer(origin, departure_date, destination)
    json(conn, %{"data" => %{"cheapestOffer" => %{"amount" => amount, "airline" => airline}}})
  end
end
