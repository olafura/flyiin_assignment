import Config

config :flyiin_assignment, FlyiinAssignmentWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "localhost", port: {:system, "PORT"}],
  server: true

# Do not print debug messages in production
config :logger, level: :info

config :flyiin_assignment, FlyiinAssignment.Airline.AirFranceKLM,
  travel_agency: %{
    name: System.fetch_env!("AIR_FRANCE_KLM_TRAVEL_AGENT_NAME"),
    city: System.fetch_env!("AIR_FRANCE_KLM_TRAVEL_AGENT_CITY"),
    iata_number: System.fetch_env!("AIR_FRANCE_KLM_TRAVEL_AGENT_IATA_NUMBER"),
    id: System.fetch_env!("AIR_FRANCE_KLM_TRAVEL_AGENT_ID")
  },
  headers: [
    {"SOAPAction",
     "\"http://www.af-klm.com/services/passenger/ProvideAirShopping/provideAirShopping\""},
    {"Content-Type", "text/xml"},
    {"api_key", System.fetch_env!("AIR_FRANCE_KLM_API_KEY")}
  ],
  url: System.fetch_env!("AIR_FRANCE_KLM_URL")

config :flyiin_assignment, FlyiinAssignment.Airline.BritishAirways,
  travel_agency: %{
    name: System.fetch_env!("BRITISH_AIRWAYS_TRAVEL_AGENT_NAME"),
    city: "",
    iata_number: System.fetch_env!("BRITISH_AIRWAYS_TRAVEL_AGENT_IATA_NUMBER"),
    id: System.fetch_env!("BRITISH_AIRWAYS_TRAVEL_AGENT_ID")
  },
  headers: [
    {"SOAPAction", "AirShoppingV01"},
    {"Content-Type", "application/xml"},
    {"Client-Key", System.fetch_env!("BRITISH_AIRWAYS_API_KEY")}
  ],
  url: System.fetch_env!("BRITISH_AIRWAYS_URL")
