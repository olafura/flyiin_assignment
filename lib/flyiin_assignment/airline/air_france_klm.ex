defmodule FlyiinAssignment.Airline.AirFranceKLM do
  @moduledoc false

  require Logger
  import SweetXml

  @spec fetch_price(
          %{city: String.t(), iata_number: String.t(), id: String.t(), name: String.t()},
          airline :: String.t(),
          origin :: String.t(),
          departure_date :: String.t(),
          destination :: String.t()
        ) :: {:ok, %{total: float}} | {:error, String.t() | charlist()}
  def fetch_price(travel_agency, airline, origin, departure_date, destination) do
    # TODO: Find way of generating the xml based rules, possible using xlst based
    # on the different versions of the schema.
    body = """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
        <soapenv:Header/>
        <soapenv:Body xmlns="http://www.iata.org/IATA/EDIST/2017.1">
          <AirShoppingRQ Version="17.1">
            <Document/>
            <Party>
              <Sender>
                <TravelAgencySender>
                  <Name>#{travel_agency.name}</Name>
                  <PseudoCity>#{travel_agency.city}</PseudoCity>
                  <IATA_Number>#{travel_agency.iata_number}</IATA_Number>
                  <AgencyID>#{travel_agency.id}</AgencyID>
                </TravelAgencySender>
              </Sender>
              <Recipient>
                <ORA_Recipient>
                  <AirlineID>#{airline}</AirlineID>
                </ORA_Recipient>
              </Recipient>
            </Party>
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
            <Preference>
              <CabinPreferences>
                <CabinType>
                  <Code>1</Code>
                </CabinType>
              </CabinPreferences>
            </Preference>
            <DataLists>
              <PassengerList>
                <Passenger>
                  <PTC>ADT</PTC>
                </Passenger>
              </PassengerList>
            </DataLists>
          </AirShoppingRQ>
        </soapenv:Body>
      </soapenv:Envelope>
    """

    %{headers: headers, url: url} =
      Application.get_env(:flyiin_assignment, __MODULE__) |> Map.new()

    with {:ok, %Mojito.Response{body: response_body, status_code: 200}}
         when bit_size(response_body) > 0 <- Mojito.request(:post, url, headers, body) do
      process_response(response_body)
    else
      other ->
        Logger.error("AirFranceKLM error with request: #{inspect(other)}")
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
        |> xpath(~x"//AirlineOffers/Offer")
        |> xmap(total: ~x"//TotalPrice/*/Total/text()"f)

      {:ok, new_response}
    else
      {:parse, error} ->
        Logger.error("AirFranceKLM parsing error: #{inspect(error)}")
        {:error, "Parsing error"}

      {:error_check, error} ->
        Logger.error("AirFranceKLM action error: #{inspect(error)}")
        {:error, error}
    end
  catch
    :exit, value ->
      Logger.error("AirFranceKLM parsing error: #{inspect(value)}")
      {:error, "Parsing error"}
  end
end
