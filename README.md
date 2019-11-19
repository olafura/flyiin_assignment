# FlyiinAssignment

This webservice provides the cheapest offer given origin, destination and departure date,
for two airline groups: Air France-KLM and British Airways

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Get a token the soap services of Air France-KLM and British Airlines.
  * Start Phoenix endpoint with `AIR_FRANCE_KLM_API_KEY=token BRITISH_AIRWAYS_API_KEY=token iex -S mix phx.server`

Now you can try running:

    curl "http://localhost:4000/findCheapestOffer?origin=BER&destination=LHR&departureDate=`date -d +10days --iso-8601` 


## Deployment

You can run the release command in the same environment as you have on your server ( CPU, Operating System ):

    MIX_ENV=prod mix release

You can then copy the `_build/prod/rel` folder that was created to a sensible location like `/var/lib` or `/opt`.

You need the following envs set on the deployed server in the init scripts.

  * `PORT` - The port of the server
  * `AIR_FRANCE_KLM_TRAVEL_AGENT_NAME` - The name of the travel agent for Air France-KLM
  * `AIR_FRANCE_KLM_TRAVEL_AGENT_CITY` - The city of the travel agent for Air France-KLM
  * `AIR_FRANCE_KLM_TRAVEL_AGENT_IATA_NUMBER` - The IATA number of the travel agent for Air France-KLM
  * `AIR_FRANCE_KLM_TRAVEL_AGENT_ID` - The id of the travel agent for Air France-KLM
  * `AIR_FRANCE_KLM_URL` - The url for the soap service for Air France-KLM
  * `AIR_FRANCE_KLM_API_KEY` - The api key for the soap service for Air France-KLM
  * `BRITISH_AIRWAYS_TRAVEL_AGENT_NAME` - The of the travel agent for British Airways
  * `BRITISH_AIRWAYS_TRAVEL_AGENT_IATA_NUMBER` - The of the travel agent for British Airways
  * `BRITISH_AIRWAYS_TRAVEL_AGENT_ID` - The of the travel agent for British Airways
  * `BRITISH_AIRWAYS_URL` - The url for the soap service for British Airways
  * `BRITISH_AIRWAYS_API_KEY` - The api key for the soap service for British Airways

You can also modify the configs in a remote instance:

    https://hexdocs.pm/mix/Mix.Tasks.Release.html#module-runtime-configuration

You can also add support for edeliver which supports having a build server and deployment server which minimizes the possible
library differences for deployement.

    https://github.com/edeliver/edeliver

The other common option is to use a containers where you use identical container for the build step as with the deployed image,
you then copy `_build/prod/rel` between the images.

    https://akoutmos.com/post/multipart-docker-and-elixir-1.9-releases/

