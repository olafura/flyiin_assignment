# FlyiinAssignment

This webservice provides the cheapest offer given origin, destination and departure date,
for two airline groups: Air France-KLM and British Airways

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Get a token the soap services of Air France-KLM and British Airlines.
  * Start Phoenix endpoint with `AIR_FRANCE_KLM_API_KEY=token BRITISH_AIRWAYS_API_KEY=token iex -S mix phx.server`

Now you can try running:

    curl "http://localhost:4000/findCheapestOffer?origin=BER&destination=LHR&departureDate=`date -d +10days --iso-8601` 

