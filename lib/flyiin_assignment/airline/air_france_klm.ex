defmodule FlyiinAssignment.Airline.AirFranceKLM do
  import SweetXml

  def get_price() do
    body = """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
        <soapenv:Header/>
        <soapenv:Body xmlns="http://www.iata.org/IATA/EDIST/2017.1">
          <AirShoppingRQ Version="17.1">
            <Document/>
            <Party>
              <Sender>
                <TravelAgencySender>
                  <Name>Test</Name>
                  <PseudoCity>PARMM211L</PseudoCity>
                  <IATA_Number>12345675</IATA_Number>
                  <AgencyID>id</AgencyID>
                </TravelAgencySender>
              </Sender>
              <Recipient>
                <ORA_Recipient>
                  <AirlineID>AF</AirlineID>
                </ORA_Recipient>
              </Recipient>
            </Party>
            <CoreQuery>
              <OriginDestinations>
                <OriginDestination>
                  <Departure>
                    <AirportCode>MUC</AirportCode>
                    <Date>2019-08-15</Date>
                  </Departure>
                  <Arrival>
                    <AirportCode>LHR</AirportCode>
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
         when bit_size(response_body) > 0 <- Mojito.request(:post, url, headers, body),
         doc <- parse(response_body) do
    end
  end
end
