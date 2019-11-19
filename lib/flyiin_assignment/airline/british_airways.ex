defmodule FlyiinAssignment.Airline.BritishAirways do
  @moduledoc false

  require Logger
  import SweetXml

  @spec fetch_price(
          %{iata_number: String.t(), id: String.t(), name: String.t()},
          airline :: String.t(),
          origin :: String.t(),
          departure_date :: String.t(),
          destination :: String.t()
        ) :: {:ok, %{total: float()}} | {:error, String.t() | charlist()}
  def fetch_price(travel_agency, _airline, origin, departure_date, destination) do
    body = """
      <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
        <s:Body xmlns="http://www.iata.org/IATA/EDIST">
          <AirShoppingRQ Version="3.0" xmlns="http://www.iata.org/IATA/EDIST">
            <PointOfSale>
              <Location>
                <CountryCode>DE</CountryCode>
              </Location>
            </PointOfSale>
            <Document/>
            <Party>
              <Sender>
                <TravelAgencySender>
                  <Name>#{travel_agency.name}</Name>
                  <IATA_Number>#{travel_agency.iata_number}</IATA_Number>
                  <AgencyID>#{travel_agency.id}</AgencyID>
                </TravelAgencySender>
              </Sender>
            </Party>
            <Travelers>
              <Traveler>
                <AnonymousTraveler>
                  <PTC Quantity="1">ADT</PTC>
                </AnonymousTraveler>
              </Traveler>
            </Travelers>
            <CoreQuery>
              <OriginDestinations>
                <OriginDestination>
                  <Departure>
                    <AirportCode>#{origin}</AirportCode>
                    <Date>#{departure_date}</Date>
                  </Departure>
                  <Arrival>
                    <AirportCode>#{destination}</AirportCode>
                  </Arrival>
                </OriginDestination>
              </OriginDestinations>
            </CoreQuery>
          </AirShoppingRQ>
        </s:Body>
      </s:Envelope>
    """

    %{headers: headers, url: url} =
      Application.get_env(:flyiin_assignment, __MODULE__) |> Map.new()

    case Mojito.request(:post, url, headers, body) do
      {:ok, %Mojito.Response{body: response_body, status_code: 200}}
      when bit_size(response_body) > 0 ->
        process_response(response_body)

      other ->
        Logger.error("BritishAirways error with request: #{inspect(other)}")
        {:error, "Error with request"}
    end
  end

  @spec process_response(body :: String.t()) ::
          {:ok, %{total: float}} | {:error, String.t() | charlist()}
  def process_response(body) do
    with {:parse, doc} when is_tuple(doc) <- {:parse, parse(body)},
         {:error_check, nil} <- {:error_check, xpath(doc, ~x"//Errors/Error/@ShortText")} do
      new_response =
        doc
        |> xpath(~x"//AirlineOffers/AirlineOffer")
        |> xmap(total: ~x"//TotalPrice/SimpleCurrencyPrice/text()"f)

      {:ok, new_response}
    else
      {:parse, error} ->
        Logger.error("BritishAirways parsing error: #{inspect(error)}")
        {:error, "Parsing error"}

      {:error_check, error} ->
        Logger.error("BritishAirways action error: #{inspect(error)}")
        {:error, error}
    end
  catch
    :exit, value ->
      Logger.error("AirFranceKLM parsing error: #{inspect(value)}")
      {:error, "Parsing error"}
  end
end
