use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :flyiin_assignment, FlyiinAssignmentWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :flyiin_assignment, FlyiinAssignment.Airline.AirFranceKLM,
  travel_agency: %{name: "test", city: "PARMM211L", iata_number: "12345675", id: "id"},
  headers: [
    {"SOAPAction",
     "\"http://www.af-klm.com/services/passenger/ProvideAirShopping/provideAirShopping\""},
    {"Content-Type", "text/xml"},
    {"api_key", System.get_env("AIR_FRANCE_KLM_API_KEY")}
  ],
  url: "https://ndc-rct.airfranceklm.com/passenger/distribmgmt/001448v01/EXT"

config :flyiin_assignment, FlyiinAssignment.Airline.BritishAirways,
  headers: [
    {"SOAPAction", "AirShoppingV01"},
    {"Content-Type", "application/xml"},
    {"Client-Key", System.get_env("BRITISH_AIRWAYS_API_KEY")}
  ],
  url: "https://test.api.ba.com/selling-distribution/AirShopping/V2"
